import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final regionId = args['regionId'];
    final categoryName = args['categoryName'];

    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Restaurants'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('regions')
            .doc(regionId)
            .collection('restaurants')
            .where('category', isEqualTo: categoryName)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching restaurants'));
          }

          final restaurants = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'name': data['name'] as String,
              'image': data['image'] as String,
            };
          }).toList();

          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(restaurants[index]['name']),
                  leading: Image.network (restaurants[index]['image'],
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
                    // Handle restaurant tap, e.g., navigate to restaurant details
                    Navigator.pushNamed(
                      context,
                      '/restaurant-details',
                      arguments: restaurants[index]['name'],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}