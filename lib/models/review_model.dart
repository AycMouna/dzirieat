import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String userId;
  final String restaurantId;
  final String username;
  final String userProfileImage;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> replies;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.username,
    this.userProfileImage = '',
    required this.rating,
    required this.comment,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? replies,
  }) :
        createdAt = createdAt ?? DateTime.now(),
        likes = likes ?? [],
        replies = replies ?? [];

  // Convert Firestore document to ReviewModel
  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      restaurantId: data['restaurantId'] ?? '',
      username: data['username'] ?? 'Anonymous',
      userProfileImage: data['userProfileImage'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: List<String>.from(data['likes'] ?? []),
      replies: List<String>.from(data['replies'] ?? []),
    );
  }

  // Convert ReviewModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'restaurantId': restaurantId,
      'username': username,
      'userProfileImage': userProfileImage,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
      'replies': replies,
    };
  }

  // Helper methods
  ReviewModel copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? username,
    String? userProfileImage,
    double? rating,
    String? comment,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? replies,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      username: username ?? this.username,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      replies: replies ?? this.replies,
    );
  }

  // Validation method
  bool isValid() {
    return userId.isNotEmpty &&
        restaurantId.isNotEmpty &&
        rating > 0 &&
        rating <= 5 &&
        comment.isNotEmpty;
  }

  // Calculate time ago
  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${difference.inDays ~/ 365} year${difference.inDays ~/ 365 != 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30} month${difference.inDays ~/ 30 != 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays != 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours != 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes != 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}