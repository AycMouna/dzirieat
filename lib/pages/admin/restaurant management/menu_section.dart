import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_menu_item_dialog.dart';
import 'edit_menu_item_dialog.dart';
import 'delete_menu_item_dialog.dart';

class MenuSection extends StatelessWidget {
  final String restaurantId;

  MenuSection({required this.restaurantId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _showAddMenuItemDialog(context),
          child: Text('Add New Menu Item'),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('restaurants').doc(restaurantId).collection('menu').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              var menuItems = snapshot.data!.docs;

              return ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  var menuItem = menuItems[index];
                  return ListTile(
                    title: Text(menuItem['name']),
                    subtitle: Text('\$${menuItem['price'].toString()}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditMenuItemDialog(context, menuItem);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteMenuItemDialog(context, menuItem);
                          },
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

  void _showAddMenuItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddMenuItemDialog(restaurantId: restaurantId);
      },
    );
  }

  void _showEditMenuItemDialog(BuildContext context, QueryDocumentSnapshot menuItem) {
    showDialog(
      context: context,
      builder: (context) {
        return EditMenuItemDialog(menuItem: menuItem);
      },
    );
  }

  void _showDeleteMenuItemDialog(BuildContext context, QueryDocumentSnapshot menuItem) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteMenuItemDialog(
          menuItemName: menuItem['name'],
          menuItemId: menuItem.id,
          restaurantId: restaurantId,
        );
      },
    );
  }
}