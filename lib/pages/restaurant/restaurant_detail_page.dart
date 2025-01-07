import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RestaurantDetailsPage extends StatefulWidget {
  @override
  _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  static const Color burgundy = Color(0xFF800020);
  Map<String, dynamic>? restaurant;
  double averageRating = 0.0;
  bool isLoading = true;
  List<Map<String, dynamic>> reviews = [];
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRestaurantData();
    });
  }

  Future<void> _fetchRestaurantData() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Map<String, dynamic>) {
      setState(() {
        isLoading = false;
      });
      print('No arguments passed to restaurant details page.');
      return;
    }

    try {
      print('Fetching restaurant with args:');
      print(args);

      final restaurantDoc = await FirebaseFirestore.instance
          .collection('regions')
          .doc(args['regionId'])
          .collection('categories')
          .doc(args['categoryId'])
          .collection('restaurants')
          .doc(args['id'])
          .get();

      if (!restaurantDoc.exists) {
        print('Restaurant document does not exist');
        return;
      }

      // Include the IDs in the restaurant data
      final restaurantData = {
        ...restaurantDoc.data()!,
        'id': args['id'],
        'regionId': args['regionId'],
        'categoryId': args['categoryId'],
      };

      // Fetch reviews
      final reviewsSnapshot = await restaurantDoc.reference
          .collection('reviews')
          .get();

      final reviewsList = reviewsSnapshot.docs.map((doc) {
        return {
          'comment': doc.data()['comment'] ?? 'No comment',
          'rating': doc.data()['rating'] as double,
          'userId': doc.data()['userId'] ?? 'Anonymous'
        };
      }).toList();

      // Calculate average rating
      final avgRating = reviewsList.isNotEmpty
          ? reviewsList.map((e) => e['rating']).reduce((a, b) => a + b) / reviewsList.length
          : 0.0;

      // Check favorite status
      bool isFav = false;
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final favoriteDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(args['id'])
            .get();
        isFav = favoriteDoc.exists;
      }

      setState(() {
        restaurant = restaurantData;
        reviews = reviewsList;
        averageRating = avgRating;
        isFavorite = isFav;
        isLoading = false;
      });

      print('Restaurant data loaded:');
      print(restaurant);
    } catch (e, stackTrace) {
      print('Error fetching restaurant data: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading restaurant data. Please try again.')),
      );
    }
  }

  void _toggleFavorite() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to add to favorites')),
      );
      return;
    }

    final favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites');

    try {
      if (isFavorite) {
        await favoritesRef.doc(restaurant!['id']).delete();
      } else {
        await favoritesRef.doc(restaurant!['id']).set({
          'name': restaurant!['name'],
          'image': restaurant!['image'],
          'rating': averageRating,
          'regionId': restaurant!['regionId'],
          'categoryId': restaurant!['categoryId'],
          'id': restaurant!['id'],
        });
      }

      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      print('Error toggling favorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorites. Please try again.')),
      );
    }
  }

  void _showAddReviewDialog() {
    final TextEditingController commentController = TextEditingController();
    double rating = 3.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                maxRating: 5,
                allowHalfRating: true,
                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: 'Your review'),
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
                if (commentController.text.isNotEmpty) {
                  _addReview(commentController.text, rating);
                }
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addReview(String comment, double rating) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to add a review')),
      );
      return;
    }

    try {
      final reviewRef = FirebaseFirestore.instance
          .collection('regions')
          .doc(restaurant!['regionId'])
          .collection('categories')
          .doc(restaurant!['categoryId'])
          .collection('restaurants')
          .doc(restaurant!['id'])
          .collection('reviews');

      await reviewRef.add({
        'comment': comment,
        'rating': rating,
        'date': FieldValue.serverTimestamp(),
        'userId': userId,
      });

      _fetchRestaurantData();
    } catch (e) {
      print('Error adding review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding review. Please try again.')),
      );
    }
  }

  void _navigateToMenu() {
    print('Restaurant data before navigation:');
    print(restaurant);

    if (restaurant == null) {
      print('Error: Restaurant is null');
      return;
    }

    final menuArgs = {
      'regionId': restaurant!['regionId'],
      'categoryId': restaurant!['categoryId'],
      'id': restaurant!['id'],
    };

    print('Menu navigation arguments:');
    print(menuArgs);

    Navigator.pushNamed(
      context,
      '/menu',
      arguments: menuArgs,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (restaurant == null) {
      return Scaffold(
        body: Center(child: Text('Restaurant not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: burgundy,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(restaurant!['name']),
              background: Image.network(
                restaurant!['image'] ?? 'assets/images/default.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant!['description'] ?? 'No description available',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Phone: ${restaurant!['phone'] ?? 'N/A'}'),
                  Text('Location: ${restaurant!['location'] ?? 'N/A'}'),
                  Text('Hours: ${restaurant!['hours'] ?? 'N/A'}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showAddReviewDialog,
                    child: Text('Add Review'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: burgundy,
                      minimumSize: Size(double.infinity, 40),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _navigateToMenu,
                    child: Text('View Menu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: burgundy,
                      minimumSize: Size(double.infinity, 40),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Reviews',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: review['rating'],
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20,
                                  ),
                                  Spacer(),
                                  Text(
                                    review['userId'],
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(review['comment']),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}