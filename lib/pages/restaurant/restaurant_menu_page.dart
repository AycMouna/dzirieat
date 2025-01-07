import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color burgundy = Color(0xFF800020);

class MenuPage extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const MenuPage({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> menuItems = [];
  List<Map<String, dynamic>> filteredMenuItems = [];
  bool isLoading = true;
  String searchQuery = '';
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMenuItems();
    });
  }

  bool _validateRestaurantData() {
    if (widget.restaurant['regionId'] == null ||
        widget.restaurant['categoryId'] == null ||
        widget.restaurant['id'] == null) {
      setState(() {
        errorMessage = 'Missing required restaurant data';
        isLoading = false;
      });
      print('Warning: Missing required restaurant data');
      print('Restaurant data: ${widget.restaurant}');
      return false;
    }
    return true;
  }

  Future<void> _fetchMenuItems() async {
    if (!_validateRestaurantData()) return;

    try {
      final String path = 'regions/${widget.restaurant['regionId']}/categories/${widget.restaurant['categoryId']}/restaurants/${widget.restaurant['id']}/menu';
      print('Attempting to fetch from path: $path');

      final QuerySnapshot menuSnapshot = await FirebaseFirestore.instance
          .collection('regions')
          .doc(widget.restaurant['regionId'])
          .collection('categories')
          .doc(widget.restaurant['categoryId'])
          .collection('restaurants')
          .doc(widget.restaurant['id'])
          .collection('menu')
          .get();

      print('Query completed successfully');
      print('Number of documents found: ${menuSnapshot.docs.length}');

      if (mounted) {
        setState(() {
          menuItems = menuSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'name': data['name'] ?? 'Unknown Item',
              'price': data['price']?.toString() ?? '0',
              'image': data['image'] ?? '',
              'description': data['description'] ?? '',
              'category': data['category'] ?? 'Uncategorized',
            };
          }).toList();

          filteredMenuItems = menuItems;
          isLoading = false;
          errorMessage = null;
        });
      }
    } catch (e, stackTrace) {
      print('Error fetching menu items: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load menu items. Please try again later.';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading menu items. Please try again.'),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                _fetchMenuItems();
              },
            ),
          ),
        );
      }
    }
  }

  void _filterMenuItems(String query) {
    setState(() {
      searchQuery = query;
      filteredMenuItems = menuItems.where((item) {
        final name = item['name'].toString().toLowerCase();
        final description = item['description'].toString().toLowerCase();
        final category = item['category'].toString().toLowerCase();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) ||
            description.contains(searchLower) ||
            category.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: burgundy,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                isLoading = true;
                errorMessage = null;
              });
              _fetchMenuItems();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: burgundy,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              onChanged: _filterMenuItems,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search menu items...',
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white24,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(burgundy),
              ),
            )
                : errorMessage != null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        errorMessage = null;
                      });
                      _fetchMenuItems();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: burgundy,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text('Retry'),
                  ),
                ],
              ),
            )
                : filteredMenuItems.isEmpty
                ? Center(
              child: Text(
                searchQuery.isEmpty
                    ? 'No menu items available'
                    : 'No items match your search',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredMenuItems.length,
              itemBuilder: (context, index) {
                final item = filteredMenuItems[index];
                return MenuItemCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const MenuItemCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item['image'].isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                item['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.fastfood,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      '₱${item['price']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: burgundy,
                      ),
                    ),
                  ],
                ),
                if (item['description'].isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text(
                    item['description'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: burgundy.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item['category'],
                    style: TextStyle(
                      color: burgundy,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}