import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteRestaurantDialog extends StatelessWidget {
  final String restaurantName;
  final String restaurantId;

  DeleteRestaurantDialog({required this.restaurantName, required this.restaurantId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _deleteRestaurant(BuildContext context) {
    _firestore.collection('restaurants').doc(restaurantId).delete().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Restaurant'),
      content: Text('Are you sure you want to delete the restaurant "$restaurantName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _deleteRestaurant(context),
          child: Text('Delete'),
        ),
      ],
    );
  }
}