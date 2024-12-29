import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  static const Color burgundy = Color(0xFF800020);
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredCategories = [];

  final List<Map<String, String>> categories = [
    {'name': 'Plats traditionnels', 'image': 'assets/images/mesfouf.jpg'},
    {'name': 'Pizza', 'image': 'assets/images/pizza.jpg'},
    {'name': 'Gelato', 'image': 'assets/images/gelato.jpg'},
    {'name': 'Italien', 'image': 'assets/images/italien1.jpg'},
    {'name': 'Asiatique', 'image': 'assets/images/asiatique1.jpg'},
    {'name': 'Cafeteria', 'image': 'assets/images/cafeteria.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    filteredCategories = categories;
  }

  void _filterCategories(String query) {
    setState(() {
      filteredCategories = categories
          .where((category) =>
          category['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final regionName = ModalRoute.of(context)!.settings.arguments as String?;

    if (regionName == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text('Region not found', style: TextStyle(fontSize: 20))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories - $regionName', style: TextStyle(color: Colors.white)),
        backgroundColor: burgundy,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCategories,
              decoration: InputDecoration(
                hintText: 'Search categories...',
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
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: filteredCategories.isEmpty // Disable GestureDetector if list is empty
                      ? Stack( // Show image and text even if not tappable
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(categories[index]['image']!, fit: BoxFit.cover,), // Use original categories list
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: Text(
                          categories[index]['name']!, // Use original categories list
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                      : GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/restaurant-list', arguments: {
                        'region': regionName,
                        'category': filteredCategories[index]['name'],
                      });
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(filteredCategories[index]['image']!, fit: BoxFit.cover,),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Text(
                            filteredCategories[index]['name']!,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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