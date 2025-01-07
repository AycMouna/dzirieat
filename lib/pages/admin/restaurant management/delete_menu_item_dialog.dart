import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteMenuItemDialog extends StatelessWidget {
  final String menuItemName;
  final String menuItemId;
  final String restaurantId;

  DeleteMenuItemDialog({required this.menuItemName, required this.menuItemId, required this.restaurantId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _deleteMenuItem(BuildContext context) {
    _firestore.collection('restaurants').doc(restaurantId).collection('menu').doc(menuItemId).delete().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Menu Item'),
      content: Text('Are you sure you want to delete the menu item "$menuItemName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _deleteMenuItem(context),
          child: Text('Delete'),
        ),
      ],
    );
  }
}