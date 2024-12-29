import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantFunctions {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save Restaurant Data
  Future<void> saveRestaurant(String name, String image, String category) async {
    await _db.collection('restaurants').add({
      'name': name,
      'image': image,
      'category': category,
      'likes': 0,
      'comments': [],
    });
  }

  // Fetch Restaurant Data
  Future<List<Map<String, dynamic>>> getRestaurants() async {
    QuerySnapshot snapshot = await _db.collection('restaurants').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}