import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRestaurantDialog extends StatefulWidget {
  final String regionId; // Accept regionId

  AddRestaurantDialog({required this.regionId}); // Constructor

  @override
  _AddRestaurantDialogState createState() => _AddRestaurantDialogState();
}

class _AddRestaurantDialogState extends State<AddRestaurantDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? _selectedCategoryId;
  List<Map<String, String>> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('categories').get();
      final fetchedCategories = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] as String,
        };
      }).toList();

      setState(() {
        _categories = fetchedCategories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> _addRestaurant() async {
    if (_nameController.text.isNotEmpty && _selectedCategoryId != null) {
      await FirebaseFirestore.instance.collection('regions').doc(widget.regionId).collection('restaurants').add({
        'name': _nameController .text,
        'image': _imageUrlController.text.isNotEmpty ? _imageUrlController.text : 'https://example.com/default-restaurant.png',
        'categoryId': _selectedCategoryId,
      }).then((_) {
        Navigator.of(context).pop(); // Close the dialog after adding
      }).catchError((error) {
        print("Error adding restaurant: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Restaurant'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Restaurant Name'),
          ),
          TextField(
            controller: _imageUrlController,
            decoration: InputDecoration(labelText: 'Image URL (optional)'),
          ),
          DropdownButtonFormField<String>(
            value: _selectedCategoryId,
            hint: Text('Select Category'),
            items: _categories.map((category) {
              return DropdownMenuItem<String>(
                value: category['id'],
                child: Text(category['name']!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategoryId = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close the dialog
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addRestaurant, // Call the add restaurant function
          child: Text('Add'),
        ),
      ],
    );
  }
}