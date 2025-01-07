import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRegionDialog extends StatefulWidget {
  final QueryDocumentSnapshot region;

  EditRegionDialog({required this.region});

  @override
  _EditRegionDialogState createState() => _EditRegionDialogState();
}

class _EditRegionDialogState extends State<EditRegionDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.region['name'];
    _imageUrlController.text = widget.region['image'] ?? ''; // Use empty string if image is null
  }

  void _editRegion() {
    if (_nameController.text.isNotEmpty) {
      // Set a default image URL if none is provided
      String imageUrl = _imageUrlController.text.isNotEmpty ? _imageUrlController.text : 'https://example.com/default-image.png';

      _firestore.collection('regions').doc(widget.region.id).update({
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
      title: Text('Edit Region'),
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
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _editRegion,
          child: Text('Save'),
        ),
      ],
    );
  }
}