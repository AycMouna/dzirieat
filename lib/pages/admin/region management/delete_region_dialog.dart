import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteRegionDialog extends StatelessWidget {
  final String regionName;
  final String regionId;

  DeleteRegionDialog({required this.regionName, required this.regionId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _deleteRegion(BuildContext context) {
    _firestore.collection('regions').doc(regionId).delete().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Region'),
      content: Text('Are you sure you want to delete the region "$regionName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _deleteRegion(context),
          child: Text('Delete'),
        ),
      ],
    );
  }
}