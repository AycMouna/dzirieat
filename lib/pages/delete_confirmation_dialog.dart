import 'package:flutter/material.dart';


class DeleteConfirmationDialog extends StatelessWidget {
  final String restaurantName;
  final Function onDeleteConfirmed;

  const DeleteConfirmationDialog({
    required this.restaurantName,
    required this.onDeleteConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Delete'),
      content: Text('Are you sure you want to delete "$restaurantName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onDeleteConfirmed();
            Navigator.pop(context);
          },
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}