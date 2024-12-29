import 'package:flutter/material.dart';
import 'package:dzirieat_app/firebase_service.dart';


class EditRestaurantPage extends StatefulWidget {
  final Restaurant restaurant;

  EditRestaurantPage({required this.restaurant});

  @override
  _EditRestaurantPageState createState() => _EditRestaurantPageState();
}

class _EditRestaurantPageState extends State<EditRestaurantPage> {
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final regionController = TextEditingController();
  final statusController = TextEditingController();
  String? imagePath; // Variable to hold the image path
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.restaurant.name;
    categoryController.text = widget.restaurant.category;
    regionController.text = widget.restaurant.region;
    statusController.text = widget.restaurant.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Restaurant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: categoryController,
          decoration: InputDecoration(labelText: 'Category'),
        ),
        TextField(
          controller: regionController,
          decoration: InputDecoration(labelText: 'Region'),
        ),
            TextField(
              controller: statusController,
              decoration: InputDecoration(labelText: 'Status'),
            ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: () async {
          final updatedRestaurant = Restaurant(
            id: widget.restaurant.id,
            name: nameController.text,
            category: categoryController.text,
            region: regionController.text,
            description: widget.restaurant.description,
            status: statusController.text,
            imageUrl: widget.restaurant.imageUrl,
            price: widget.restaurant.price,
            menu: widget.restaurant.menu,
          );

          await _firebaseService.updateRestaurant(updatedRestaurant);
          Navigator.pop(context, updatedRestaurant);
        },
        child: Text('Save Changes'),
      ),
      ],
    ),
    ),
    );
  }
}