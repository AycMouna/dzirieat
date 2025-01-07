import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategoryDialog extends StatefulWidget {
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addCategory() {
    if (_nameController.text.isNotEmpty) {
      // Set a default image URL if none is provided
      String imageUrl = _imageUrlController.text.isNotEmpty
          ? _imageUrlController.text
          : 'https://example.com/default-image.png'; // Replace with a valid default image URL

      // Add the new category to Firestore
      _firestore.collection('categories').add({
        'name': _nameController.text,
        'image': imageUrl,
      }).then((_) {
        Navigator.of(context).pop(); // Close the dialog after adding
      }).catchError((error) {
        // Handle any errors here
        print("Error adding category: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Category Name'),
          ),
          TextField(
            controller: _imageUrlController,
            decoration: InputDecoration(labelText: 'Image URL (optional)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close the dialog
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addCategory, // Call the add category function
          child: Text('Add'),
        ),
      ],
    );
  }
}