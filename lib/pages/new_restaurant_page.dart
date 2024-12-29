import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewRestaurantPage extends StatefulWidget {
  @override
  _NewRestaurantPageState createState() => _NewRestaurantPageState();
}

class _NewRestaurantPageState extends State<NewRestaurantPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;
  String _selectedCategory = 'Restaurant';
  final List<Map<String, dynamic>> _menuItems = [];
  final _categories = ['Restaurant', 'Cafeteria', 'Italien','Asiatique', 'Traditional','Gelato','Pizza'];
  List<String> _regions = [];
  String? _selectedRegion;

  @override
  void initState() {
    super.initState();
    _fetchRegions();
  }

  Future<void> _fetchRegions() async {
    try {
      _regions = ['Constantine', 'Alger', 'Oran', 'Annaba', 'Skikda', 'Bejaia','Setif','Biskra']; // More regions
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching regions: $e')),
      );
    }
    if (mounted) setState(() {});
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _pickMenuItemImage(Map<String, dynamic> menuItem) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        menuItem['image'] = File(pickedFile.path);
      });
    }
  }

  void _showAddMenuItemDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final menuItem = <String, dynamic>{};

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add Menu Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price (DA)'),
                  keyboardType: TextInputType.number,
                ),
                GestureDetector(
                  onTap: () => _pickMenuItemImage(menuItem),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: menuItem['image'] != null
                        ? Image.file(menuItem['image'] as File, fit: BoxFit.cover)
                        : Icon(Icons.add_photo_alternate, size: 50),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty) {
                    menuItem['name'] = nameController.text;
                    menuItem['price'] = priceController.text;
                    _menuItems.add(menuItem);
                    Navigator.pop(context); // Close dialog *after* adding item
                    setState((){}); //force rebuild after dialog close
                  }
                },
                child: Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final restaurantData = {
        'name': _nameController.text,
        'category': _selectedCategory,
        'description': _descriptionController.text,
        'imagePath': _imageFile?.path,
        'region': _selectedRegion,
        'menuItems': _menuItems,
      };
      print(restaurantData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restaurant created successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Restaurant')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : Icon(Icons.add_photo_alternate, size: 50),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Restaurant Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Region'),
                value: _selectedRegion,
                onChanged: (String? newValue) => setState(() => _selectedRegion = newValue),
                validator: (value) => value == null ? 'Please select a region' : null,
                items: _regions.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              ..._menuItems.map((item) => ListTile(
                leading: item['image'] != null
                    ? Image.file(item['image'] as File, width: 50, height: 50, fit: BoxFit.cover)
                    : null,
                title: Text(item['name'] ?? ''),
                subtitle: Text('${item['price']} DA'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => setState(() => _menuItems.remove(item)),
                ),
              )),
              ElevatedButton.icon(
                onPressed: _showAddMenuItemDialog,
                icon: Icon(Icons.add),
                label: Text('Add Menu Item'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Restaurant'),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}