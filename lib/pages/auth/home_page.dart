import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color burgundy = Color(0xFF800020);

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> regions = [];
  List<Map<String, String>> filteredRegions = [];

  @override
  void initState() {
    super.initState();
    _fetchRegions();
  }

  Future<void> _fetchRegions() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('regions').get();
      final fetchedRegions = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['name'] as String,
          'image': data['image'] as String,
        };
      }).toList();

      setState(() {
        regions = fetchedRegions;
        filteredRegions = fetchedRegions;
      });
    } catch (e) {
      print('Error fetching regions: $e');
    }
  }

  void _filterRegions(String query) {
    setState(() {
      filteredRegions = regions
          .where((region) => region['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regions', style: TextStyle(color: Colors.white)),
        backgroundColor: burgundy,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterRegions,
              decoration: InputDecoration(
                hintText: 'Search regions...',
                prefixIcon: Icon(Icons.search, color: burgundy),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: burgundy),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: burgundy, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredRegions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the CategoryPage with the region name
                    Navigator.pushNamed(
                      context,
                      '/category',
                      arguments: filteredRegions[index]['name'], // Pass the region name
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            filteredRegions[index]['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          color: Colors.black.withOpacity(0.4),
                          child: Text(
                            filteredRegions[index]['name']!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}