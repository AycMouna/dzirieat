// models/restaurant_model.dart
class RestaurantModel {
  final String id;
  final String name;
  final String category;
  final String region;
  final String description;
  final String imageUrl;
  final double rating;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.category,
    required this.region,
    required this.description,
    required this.imageUrl,
    this.rating = 0.0,
  });

  factory RestaurantModel.fromFirestore(Map<String, dynamic> data) {
    return RestaurantModel(
      id: data['id'],
      name: data['name'],
      category: data['category'],
      region: data['region'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      rating: data['rating'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'region': region,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }
}