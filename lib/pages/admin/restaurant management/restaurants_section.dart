import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_restaurant_dialog.dart';
import 'edit_restaurant_dialog.dart';
import 'delete_restaurant_dialog.dart';

class RestaurantsSection extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String regionId; // Required regionId

  RestaurantsSection({required this.regionId}); // Constructor to accept regionId

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _showAddRestaurantDialog(context),
          child: Text('Add New Restaurant'),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('regions').doc(regionId).collection('restaurants').snapshots(), // Fetch restaurants for the specific region
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              var restaurants = snapshot.data!.docs;

              return ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  var restaurant = restaurants[index];
                  return ListTile(
                    title: Text(restaurant['name'] ?? 'Unnamed Restaurant'), // Handle missing name
                    subtitle: Text(restaurant['categoryId'] ?? 'No Category'), // Handle missing category
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditRestaurantDialog(context, restaurant);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteRestaurantDialog(context, restaurant);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddRestaurantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddRestaurantDialog(regionId: regionId); // Pass regionId to the dialog
      },
    );
  }

  void _showEditRestaurantDialog(BuildContext context, QueryDocumentSnapshot restaurant) {
    showDialog(
      context: context,
      builder: (context) {
        return EditRestaurantDialog(restaurant: restaurant);
      },
    );
  }

  void _showDeleteRestaurantDialog(BuildContext context, QueryDocumentSnapshot restaurant) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteRestaurantDialog(
          restaurantName: restaurant['name'] ?? 'Unnamed Restaurant',
          restaurantId: restaurant.id,
        );
      },
    );
  }
}