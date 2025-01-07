import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCategoryDialog extends StatefulWidget {
  final QueryDocumentSnapshot category;

  EditCategoryDialog({required this.category});

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category['name'];
    _imageUrlController.text = widget.category['image'] ?? ''; // Use empty string if image is null
  }

  void _editCategory() {
    if (_nameController.text.isNotEmpty) {
      // Set a default image URL if none is provided
      String imageUrl = _imageUrlController.text.isNotEmpty ? _imageUrlController.text : 'https://example.com/default-image.png';

      _firestore.collection('categories').doc(widget.category.id).update({
        'name': _nameController.text,
        'image': imageUrl,
      }).then((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Category'),
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
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _editCategory,
          child: Text('Save'),
        ),
      ],
    );
  }
}