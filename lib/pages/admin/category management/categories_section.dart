import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_category_dialog.dart';
import 'edit_category_dialog.dart';
import 'delete_category_dialog.dart';

class CategoriesSection extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _showAddCategoryDialog(context),
          child: Text('Add New Category'),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('categories').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final categories = snapshot.data!.docs;

              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    leading: category['image'] != null
                        ? Image.network(
                      category['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.image_not_supported), // Fallback icon if image is missing
                    title: Text(category['name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditCategoryDialog(context, category),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _showDeleteCategoryDialog(context, category),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(),
    );
  }

  void _showEditCategoryDialog(BuildContext context, QueryDocumentSnapshot category) {
    showDialog(
      context: context,
      builder: (context) => EditCategoryDialog(category: category),
    );
  }

  void _showDeleteCategoryDialog(BuildContext context, QueryDocumentSnapshot category) {
    showDialog(
      context: context,
      builder: (context) => DeleteCategoryDialog(
        categoryName: category['name'],
        categoryId: category.id,
      ),
    );
  }
}