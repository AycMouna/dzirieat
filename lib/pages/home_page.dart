import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Define burgundy color
  static const Color burgundy = Color(0xFF800020);

  // Search controller
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredRegions = [];

  final List<Map<String, String>> regions = [
    {'name': 'Alger', 'image': 'assets/images/alger.jpg'},
    {'name': 'Oran', 'image': 'assets/images/oran.jpg'},
    {'name': 'Constantine', 'image': 'assets/images/constantine.jpg'},
    {'name': 'Setif', 'image': 'assets/images/setif.jpg'},
    {'name': 'Bejaia', 'image': 'assets/images/bejaia.jpg'},
    {'name': 'Annaba', 'image': 'assets/images/annaba.jpg'},
    {'name': 'Skikda', 'image': 'assets/images/skikda.jpg'},
    {'name': 'Biskra', 'image': 'assets/images/biskra.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    filteredRegions = regions;
  }

  // Function to filter regions based on the search query
  void _filterRegions(String query) {
    setState(() {
      filteredRegions = regions
          .where((region) =>
          region['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regions', style: TextStyle(color: Colors.white)),
        backgroundColor: burgundy, // Use burgundy color
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterRegions, // Call _filterRegions on text change
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
          // Regions Grid
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
                    // Navigate to Category Page with selected region
                    Navigator.pushNamed(
                      context,
                      '/category',
                      arguments: filteredRegions[index]['name'],
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Image that fills the card
                        Positioned.fill(
                          child: Image.asset(
                            filteredRegions[index]['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Overlay with centered text
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
