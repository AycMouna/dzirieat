import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Map<String, String>> categories = [];
  String? regionId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCategories();
    });
  }

  Future<void> _fetchCategories() async {
    final regionName = ModalRoute.of(context)!.settings.arguments as String?;
    if (regionName == null) {
      print('Region name is null');
      return;
    }

    try {
      // Fetch the region ID
      final regionsSnapshot = await FirebaseFirestore.instance
          .collection('regions')
          .where('name', isEqualTo: regionName)
          .get();

      if (regionsSnapshot.docs.isEmpty) {
        print('No region found with name: $regionName');
        return;
      }

      // Get the region ID
      regionId = regionsSnapshot.docs.first.id;

      // Fetch the categories
      final categoriesSnapshot = await FirebaseFirestore.instance
          .collection('regions')
          .doc(regionId)
          .collection('categories')
          .get();

      final fetchedCategories = categoriesSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['name'] as String,
          'image': data['image'] as String,
        };
      }).toList();

      if (mounted) {
        setState(() {
          categories = fetchedCategories;
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(categories[index]['name']!),
              leading: Image.network(
                categories[index]['image']!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.error),
                  );
                },
              ),
              onTap: () {
                // Handle category tap, e.g., navigate to a restaurant list
                Navigator.pushNamed(
                  context,
                  '/restaurant-list',
                  arguments: {
                    'regionId': regionId,
                    'categoryName': categories[index]['name'],
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}