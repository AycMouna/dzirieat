import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  static const Color burgundy = Color(0xFF800020);

  final List<Map<String, dynamic>> allMenuItems = [
    {
      'name': 'Couscous Royal',
      'image': 'assets/images/couscous.jpg',
      'description':
      'Traditional couscous served with lamb, merguez, and seasonal vegetables',
      'price': '1200 DA',
      'category': 'Main Dishes',
    },
    {
      'name': 'Chorba Frik',
      'image': 'assets/images/chorba.jpg',
      'description':
      'Traditional Algerian soup with lamb and crushed wheat',
      'price': '400 DA',
      'category': 'Soups',
    },
    {
      'name': 'Bourek',
      'image': 'assets/images/bourek.jpg',
      'description':
      'Crispy phyllo rolls filled with minced meat and cheese',
      'price': '300 DA',
      'category': 'Starters',
    },
    {
      'name': 'Tajine Zitoune',
      'image': 'assets/images/tajine.jpg',
      'description': 'Chicken tajine with olives and preserved lemons',
      'price': '900 DA',
      'category': 'Main Dishes',
    },
    {
      'name': 'Pizza Margherita',
      'image': 'assets/images/pizza.jpg',
      'description': 'Classic pizza with tomato, mozzarella, and basil',
      'price': '700 DA',
      'category': 'Main Dishes',
    },
    {
      'name': 'Tiramisu',
      'image': 'assets/images/tiramisu.jpg',
      'description':
      'Italian dessert with coffee-soaked ladyfingers and mascarpone',
      'price': '500 DA',
      'category': 'Desserts',
    },
  ];

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> _filteredMenuItems = [];
  List<String> _searchKeywords = [];

  @override
  void initState() {
    super.initState();
    _filteredMenuItems = widget.allMenuItems;
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Filter Menu Items'),
              content: TextField(
                autofocus: true, // Automatically focus the text field
                onChanged: (value) {
                  setState(() {
                    _searchKeywords = value
                        .split(' ')
                        .where((keyword) => keyword.isNotEmpty)
                        .toList();
                    _filterMenuItems();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter keywords (space-separated)',
                  border: OutlineInputBorder(), // Added border for better UI
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _filterMenuItems() {
    setState(() {
      _filteredMenuItems = widget.allMenuItems.where((item) =>
      _searchKeywords.isEmpty ||
          _searchKeywords.any((keyword) =>
          item['name'].toLowerCase().contains(keyword.toLowerCase()) ||
              item['description'].toLowerCase().contains(keyword.toLowerCase()) ||
              item['category'].toLowerCase().contains(keyword.toLowerCase()))).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu', style: TextStyle(color: Colors.white)),
        backgroundColor: MenuPage.burgundy,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: _filteredMenuItems.isEmpty // Handle empty list case
          ? Center(child: Text("No menu items found."))
          : CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = _filteredMenuItems[index];
                  return MenuItemCard(item: item);
                },
                childCount: _filteredMenuItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const MenuItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            item['image'],
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: MenuPage.burgundy,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item['price'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  item['category'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  item['description'],
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}