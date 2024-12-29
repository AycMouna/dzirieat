import 'package:flutter/material.dart';

class RestaurantDetailsPage extends StatefulWidget {
  @override
  _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  static const Color burgundy = Color(0xFF800020);
  bool isLiked = false; // State variable to track if the restaurant is liked/bookmarked

  @override
  Widget build(BuildContext context) {
    final restaurant = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: burgundy,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(restaurant['name']),
              background: Image.asset(
                restaurant['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              SizedBox(width: 4),
                              Text(
                                '${restaurant['rating']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            restaurant['price'],
                            style: TextStyle(
                              fontSize: 18,
                              color: burgundy,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Menu Card
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/menu',
                            arguments: restaurant,
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  size: 32,
                                  color: burgundy,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'View Menu',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Check out our delicious offerings',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: burgundy,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Address',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(restaurant['address']),
                      SizedBox(height: 16),
                      Divider(),
                      // Like/Bookmark Button
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked; // Toggle the like state
                          });
                        },
                      ),
                      // Reviews Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/add-review',
                                arguments: restaurant,
                              );
                            },
                            child: Text('Add Review'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: burgundy,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // Sample Reviews
                      ReviewCard(
                        username: "Sarah",
                        rating: 5,
                        comment: "Excellent service and amazing food!",
                        date: "2024-12-20",
                      ),
                      ReviewCard(
                        username: "Ahmed",
                        rating: 4,
                        comment: "Great atmosphere, but a bit pricey.",
                        date: "2024-12-19",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Keep the existing ReviewCard class as is

class ReviewCard extends StatelessWidget {
  final String username;
  final double rating;
  final String comment;
  final String date;

  const ReviewCard({
    required this.username,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(
                    5,
                        (index) => Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(comment),
            SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}