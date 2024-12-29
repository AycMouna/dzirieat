import 'package:flutter/material.dart';
import 'package:dzirieat_app/firebase_service.dart';
import 'package:dzirieat_app/pages/edit_restaurant_page.dart';
import 'package:dzirieat_app/pages/new_restaurant_page.dart';

class AdminPanelPage extends StatefulWidget {
  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Restaurant> restaurants = [];

  @override
  void initState() {
    super.initState();
    _firebaseService.getRestaurants().listen((restaurants) {
      setState(() {
        this.restaurants = restaurants;
      });
    });
  }

  void _refreshRestaurants() {
    // This method can be used to refresh the restaurant list if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return ListTile(
            title: Text(restaurant.name),
            subtitle: Text(restaurant.category),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditRestaurantPage(restaurant: restaurant),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Restaurant'),
                        content: Text('Are you sure you want to delete ${restaurant.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await _firebaseService.deleteRestaurant(restaurant.id);
                              setState(() {
                                restaurants.removeAt(index);
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewRestaurantPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}