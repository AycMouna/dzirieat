import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantListPage extends StatefulWidget {
  static const Color burgundy = Color(0xFF800020);

  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRestaurants();
    });
  }

  Future<void> _fetchRestaurants() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args == null) {
      print('Arguments are null!');
      return;
    }

    final String regionId = args['regionId'] as String;
    final String categoryName = args['categoryName'] as String;

    try {
      final QuerySnapshot restaurantsSnapshot = await FirebaseFirestore.instance
          .collection('regions')
          .doc(regionId)
          .collection('categories')
          .where('name', isEqualTo: categoryName)
          .get();

      if (restaurantsSnapshot.docs.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final categoryId = restaurantsSnapshot.docs.first.id;

      final QuerySnapshot restaurantDocs = await FirebaseFirestore.instance
          .collection('regions')
          .doc(regionId)
          .collection('categories')
          .doc(categoryId)
          .collection('restaurants')
          .get();

      final List<Map<String, dynamic>> fetchedRestaurants = restaurantDocs.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'image': data['image'] ?? '',
          'rating': data['rating']?.toDouble() ?? 0.0,
          'regionId': regionId,
          'categoryId': categoryId,
        };
      }).toList();

      setState(() {
        restaurants = fetchedRestaurants;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching restaurants: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants', style: TextStyle(color: Colors.white)),
        backgroundColor: RestaurantListPage.burgundy,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : restaurants.isEmpty
          ? Center(child: Text('No restaurants found.'))
          : ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  restaurant['image'],
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: 70);
                  },
                ),
              ),
              title: Text(restaurant['name']),
              subtitle: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  SizedBox(width: 4),
                  Text(restaurant['rating'].toStringAsFixed(1)),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/restaurant-details',
                  arguments: restaurant,
                );
              },
            ),
          );
        },
      ),
    );
  }
}