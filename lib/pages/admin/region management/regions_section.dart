import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_region_dialog.dart';
import 'edit_region_dialog.dart';
import 'delete_region_dialog.dart';

class RegionsSection extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _showAddRegionDialog(context),
          child: Text('Add New Region'),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('regions').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final regions = snapshot.data!.docs;

              return ListView.builder(
                itemCount: regions.length,
                itemBuilder: (context, index) {
                  final region = regions[index];
                  return ListTile(
                    leading: region['image'] != null
                        ? Image.network(
                      region['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.image_not_supported), // Fallback icon if image is missing
                    title: Text(region['name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditRegionDialog(context, region),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _showDeleteRegionDialog(context, region),
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

  void _showAddRegionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddRegionDialog(),
    );
  }

  void _showEditRegionDialog(BuildContext context, QueryDocumentSnapshot region) {
    showDialog(
      context: context,
      builder: (context) => EditRegionDialog(region: region),
    );
  }

  void _showDeleteRegionDialog(BuildContext context, QueryDocumentSnapshot region) {
    showDialog(
      context: context,
      builder: (context) => DeleteRegionDialog(
        regionName: region['name'],
        regionId: region.id,
      ),
    );
  }
}