import 'package:flutter/material.dart';
import 'restaurant management/restaurants_section.dart'; // Import the restaurants section
import 'category management/categories_section.dart'; // Import the categories section
import 'region management/regions_section.dart'; // Import the regions section
import 'package:cloud_firestore/cloud_firestore.dart';

enum AdminSection {
  restaurants,
  users,
  regions,
  categories,
}

class AdminPanelPage extends StatefulWidget {
  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  AdminSection _currentSection = AdminSection.restaurants; // Default to restaurants
  String? _selectedRegionId; // To hold the selected region ID
  List<Map<String, String>> _regions = []; // To hold the list of regions

  @override
  void initState() {
    super.initState();
    _fetchRegions(); // Fetch regions when the admin panel is initialized
  }

  Future<void> _fetchRegions() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('regions').get();
      final fetchedRegions = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] as String,
        };
      }).toList();

      setState(() {
        _regions = fetchedRegions;
        if (_regions.isNotEmpty) {
          _selectedRegionId = _regions.first['id']; // Set the first region as default
        }
      });
    } catch (e) {
      print('Error fetching regions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Color(0xFF800020), // Burgundy color
      ),
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 250,
            color: Colors.grey[200],
            child: ListView(
              children: [
                _buildSidebarItem(
                  icon: Icons.restaurant,
                  label: 'Restaurants',
                  section: AdminSection.restaurants,
                ),
                _buildSidebarItem(
                  icon: Icons.category,
                  label: 'Categories',
                  section: AdminSection.categories,
                ),
                _buildSidebarItem(
                  icon: Icons.location_city,
                  label: 'Regions',
                  section: AdminSection.regions,
                ),
                // Add more sections as needed
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                if (_currentSection == AdminSection.restaurants)
                  DropdownButton<String>(
                    value: _selectedRegionId,
                    hint: Text('Select Region'),
                    items: _regions.map((region) {
                      return DropdownMenuItem<String>(
                        value: region['id'],
                        child: Text(region['name']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRegionId = value; // Update selected region ID
                      });
                    },
                  ),
                Expanded(
                  child: _buildCurrentSection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required AdminSection section,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: _currentSection == section ? Color(0xFF800020) : Colors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: _currentSection == section ? Color(0xFF800020) : Colors.black,
        ),
      ),
      selected: _currentSection == section,
      onTap: () {
        setState(() {
          _currentSection = section;
        });
      },
    );
  }

  Widget _buildCurrentSection() {
    switch (_currentSection) {
      case AdminSection.restaurants:
        return RestaurantsSection(regionId: _selectedRegionId!); // Pass the selected region ID
      case AdminSection.categories:
        return CategoriesSection(); // Display the categories section
      case AdminSection.regions:
        return RegionsSection(); // Display the regions section
    // Add cases for other sections as needed
      default:
        return Container(); // Default case
    }
  }
}