import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRestaurantDialog extends StatefulWidget {
  final QueryDocumentSnapshot restaurant;

  EditRestaurantDialog({required this.restaurant});

  @override
  _EditRestaurantDialogState createState() => _EditRestaurantDialogState();
}

class _EditRestaurantDialogState extends State<EditRestaurantDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.restaurant['name'];
    _categoryController.text = widget.restaurant['category'];
  }

  void _editRestaurant() {
    if (_nameController.text.isNotEmpty && _categoryController.text.isNotEmpty) {
      _firestore.collection('restaurants').doc(widget.restaurant.id).update({
        'name': _nameController.text,
        'category': _categoryController.text,
      }).then((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Restaurant'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Restaurant Name'),
          ),
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(labelText: 'Category'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _editRestaurant,
          child: Text('Save'),
        ),
      ],
    );
  }
}