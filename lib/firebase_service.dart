
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Restaurant {
  final String id;
  final String name;
  final String category;
  final String region;
  final String description;
  final String status;
  final String imageUrl;
  final double rating;
  final int totalReviews;
  final String price;
  final Map<String, dynamic> menu;

  Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.region,
    required this.description,
    required this.status,
    required this.imageUrl,
    this.rating = 0.0,
    this.totalReviews = 0,
    required this.price,
    required this.menu,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'region': region,
      'description': description,
      'status': status,
      'imageUrl': imageUrl,
      'rating': rating,
      'totalReviews': totalReviews,
      'price': price,
      'menu': menu,
    };
  }
}

  class Review {
  final String id;
  final String restaurantId;
  final String userId;
  final String username;
  final double rating;
  final String comment;
  final DateTime date; // This is the field for the date of the review

  Review({
  required this.id,
  required this.restaurantId,
  required this.userId,
  required this.username,
  required this.rating,
  required this.comment,
  required this.date, // Ensure this is included
  });

  Map<String, dynamic> toMap() {
  return {
  'id': id,
  'restaurantId': restaurantId,
  'userId': userId,
  'username': username,
  'rating': rating,
  'comment': comment,
  'date': date.toIso8601String(), // Convert DateTime to String for Firestore
  };
  }
  }

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Restaurant Operations
  Future<void> createRestaurant(Restaurant restaurant) async {
    await _firestore.collection('restaurants').doc(restaurant.id).set(restaurant.toMap());
  }

  Future<void> updateRestaurant(Restaurant restaurant) async {
    await _firestore.collection('restaurants').doc(restaurant.id).update(restaurant.toMap());
  }

  Future<void> deleteRestaurant(String restaurantId) async {
    await _firestore.collection('restaurants').doc(restaurantId).delete();
  }

  Stream<List<Restaurant>> getRestaurants() {
    return _firestore.collection('restaurants').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Restaurant(
          id: doc.id,
          name: data['name'],
          category: data['category'],
          region: data['region'],
          description: data['description'],
          status: data['status'],
          imageUrl: data['imageUrl'],
          rating: data['rating'],
          totalReviews: data['totalReviews'],
          price: data['price'],
          menu: data['menu'],
        );
      }).toList();
    });
  }

  // Review Operations
  Future<void> addReview(Review review) async {
    final batch = _firestore.batch();

    // Add review
    final reviewRef = _firestore.collection('reviews').doc();
    batch.set(reviewRef, review.toMap());

    // Update restaurant rating
    final restaurantRef = _firestore.collection('restaurants').doc(review.restaurantId);
    final restaurantDoc = await restaurantRef.get();
    final currentRating = restaurantDoc.data()?['rating'] ?? 0.0;
    final currentReviews = restaurantDoc.data()?['totalReviews'] ?? 0;

    final newTotalReviews = currentReviews + 1;
    final newRating = ((currentRating * currentReviews) + review.rating) / newTotalReviews;

    batch.update(restaurantRef, {
      'rating': newRating,
      'totalReviews': newTotalReviews,
    });

    await batch.commit();
  }

  Stream<List<Review>> getRestaurantReviews(String restaurantId) {
    return _firestore
        .collection('reviews')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Review(
          id: doc.id,
          restaurantId: data['restaurantId'],
          userId: data['userId'],
          username: data['username'],
          rating: data['rating'],
          comment: data['comment'],
          date: DateTime.parse(data['date']),
        );
      }).toList();
    });
  }

  // User Likes Operations
  Future<void> toggleLike(String userId, String restaurantId) async {
    final userLikesRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('likes')
        .doc(restaurantId);

    final doc = await userLikesRef.get();
    if (doc.exists) {
      await userLikesRef.delete();
    } else {
      await userLikesRef.set({
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<List<String>> getUserLikedRestaurants(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('likes')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }
}