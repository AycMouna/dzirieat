import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRegionDialog extends StatefulWidget {
  @override
  _AddRegionDialogState createState() => _AddRegionDialogState();
}

class _AddRegionDialogState extends State<AddRegionDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  Future<void> _addRegion() async {
    if (_nameController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('regions').add({
        'name': _nameController.text,
        'image': _imageUrlController.text.isNotEmpty
            ? _imageUrlController.text
            : 'https://example.com/default-region.png',
      }).then((_) {
        Navigator.of(context).pop(); // Close the dialog after adding
      }).catchError((error) {
        print("Error adding region: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Region'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Region Name'),
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
          onPressed: _addRegion, // Call the add region function
          child: Text('Add'),
        ),
      ],
    );
  }
}