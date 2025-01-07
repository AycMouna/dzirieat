import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final String categoryName;
  final String categoryId;

  DeleteCategoryDialog({required this.categoryName, required this.categoryId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _deleteCategory(BuildContext context) {
    _firestore.collection('categories').doc(categoryId).delete().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Category'),
      content: Text('Are you sure you want to delete the category "$categoryName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _deleteCategory(context),
          child: Text('Delete'),
        ),
      ],
    );
  }
}