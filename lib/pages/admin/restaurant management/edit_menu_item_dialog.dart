import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMenuItemDialog extends StatefulWidget {
  final QueryDocumentSnapshot menuItem;

  EditMenuItemDialog({required this.menuItem});

  @override
  _EditMenuItemDialogState createState() => _EditMenuItemDialogState();
}

class _EditMenuItemDialogState extends State<EditMenuItemDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.menuItem['name'];
    _priceController.text = widget.menuItem['price'].toString();
  }

  void _editMenuItem() {
    if (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty) {
      _firestore.collection('restaurants').doc(widget.menuItem.reference.parent.parent!.id).collection('menu').doc(widget.menuItem.id).update({
        'name': _nameController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
      }).then((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Menu Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Menu Item Name'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _editMenuItem,
          child: Text('Save'),
        ),
      ],
    );
  }
}