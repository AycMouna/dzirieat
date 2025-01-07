import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { user, admin, moderator }

class UserModel {
  final String id;
  final String username;
  final String email;
  final String profileImageUrl;
  final UserRole role;
  final DateTime createdAt;
  final List<String> likedRestaurants;
  final List<String> reviewedRestaurants;
  final int totalReviews;
  final double averageRating;
  final Map<String, dynamic> preferences;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.profileImageUrl = '',
    this.role = UserRole.user,
    DateTime? createdAt,
    List<String>? likedRestaurants,
    List<String>? reviewedRestaurants,
    this.totalReviews = 0,
    this.averageRating = 0.0,
    Map<String, dynamic>? preferences,
  }) :
        createdAt = createdAt ?? DateTime.now(),
        likedRestaurants = likedRestaurants ?? [],
        reviewedRestaurants = reviewedRestaurants ?? [],
        preferences = preferences ?? {};

  // Convert Firestore document to UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      role: UserRole.values.firstWhere(
            (e) => e.toString() == 'UserRole.${data['role'] ?? 'user'}',
        orElse: () => UserRole.user,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likedRestaurants: List<String>.from(data['likedRestaurants'] ?? []),
      reviewedRestaurants: List<String>.from(data['reviewedRestaurants'] ?? []),
      totalReviews: data['totalReviews'] ?? 0,
      averageRating: (data['averageRating'] ?? 0.0).toDouble(),
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
    );
  }

  // Convert UserModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'role': role.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'likedRestaurants': likedRestaurants,
      'reviewedRestaurants': reviewedRestaurants,
      'totalReviews': totalReviews,
      'averageRating': averageRating,
      'preferences': preferences,
    };
  }

  // Helper methods
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
    UserRole? role,
    DateTime? createdAt,
    List<String>? likedRestaurants,
    List<String>? reviewedRestaurants,
    int? totalReviews,
    double? averageRating,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      likedRestaurants: likedRestaurants ?? this.likedRestaurants,
      reviewedRestaurants: reviewedRestaurants ?? this.reviewedRestaurants,
      totalReviews: totalReviews ?? this.totalReviews,
      averageRating: averageRating ?? this.averageRating,
      preferences: preferences ?? this.preferences,
    );
  }

  // Validation method
  bool isValid() {
    return username.isNotEmpty && email.isNotEmpty && email.contains('@');
  }

  // Method to update preferences
  void updatePreferences(String key, dynamic value) {
    preferences[key] = value;
  }
}