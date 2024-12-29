import 'package:flutter/material.dart';

class RestaurantListPage extends StatefulWidget {
  static const Color burgundy = Color(0xFF800020);

  final Map<String, List<Map<String, dynamic>>> restaurantData = {
    'Alger': [
      {
        'name': 'Le Petit Algérois',
        'image': 'assets/images/restaurant1.jpg',
        'rating': 4.5,
        'cuisine': 'Plats traditionnels',
        'address': '123 Rue Didouche Mourad',
        'price': '₪₪',
        'likes': 3,
      },
      {
        'name': 'Alger Restaurant 2',
        'image': 'assets/images/restaurant2.jpg',
        'rating': 4.0,
        'cuisine': 'Pizza',
        'address': 'Some other address in Alger',
        'price': '₪',
        'likes': 1,
      },
      {
        'name': 'Alger Restaurant 3',
        'image': 'assets/images/restaurant1.jpg',
        'rating': 4.2,
        'cuisine': 'Plats traditionnels',
        'address': 'Some address in Alger',
        'price': '₪₪₪',
        'likes': 5,
      },
    ],
    'Oran': [
      {
        'name': 'Oran Restaurant 1',
        'image': 'assets/images/restaurant1.jpg',
        'rating': 4.2,
        'cuisine': 'Traditionnel',
        'address': 'Some address in Oran',
        'price': '₪₪₪',
        'likes': 2,
      },
      {
        'name': 'Oran Restaurant 2',
        'image': 'assets/images/restaurant2.jpg',
        'rating': 4.7,
        'cuisine': 'Pizza',
        'address': 'Some address in Oran',
        'price': '₪',
        'likes': 4,
      },
    ],
    'Constantine': [
      {
        'name': 'Constantine Restaurant 1',
        'image': 'assets/images/takeoff1.jpg',
        'rating': 4.9,
        'cuisine': 'Plats traditionnels',
        'address': 'Some address in Constantine',
        'price': '₪₪',
        'likes': 0,
      },
    ],
  };

  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  int _minLikes = 0;
  int _maxLikes = 5;
  List<String> _searchKeywords = [];

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Filter Options'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text('Likes: $_minLikes - $_maxLikes'),
                        Expanded(
                          child: RangeSlider(
                            values: RangeValues(_minLikes.toDouble(), _maxLikes.toDouble()),
                            min: 0,
                            max: 5,
                            divisions: 5,
                            labels: RangeLabels(_minLikes.toString(), _maxLikes.toString()),
                            onChanged: (values) {
                              setState(() {
                                _minLikes = values.start.toInt();
                                _maxLikes = values.end.toInt();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchKeywords = value.split(' ').where((keyword) => keyword.isNotEmpty).toList();
                        });
                      },
                      decoration: InputDecoration(hintText: 'Enter keywords (space-separated)'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.setState((){}); // Important: rebuild the RestaurantListPage
                  },
                  child: Text('Apply Filters'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String regionName = args['region'] as String;
    final String categoryName = args['category'] as String;

    final List<Map<String, dynamic>> filteredRestaurants = (widget.restaurantData[regionName] ?? [])
        .where((restaurant) =>
    restaurant['cuisine'].toLowerCase() == categoryName.toLowerCase() &&
        restaurant['likes'] >= _minLikes &&
        restaurant['likes'] <= _maxLikes &&
        (_searchKeywords.isEmpty ||
            _searchKeywords.any((keyword) =>
            restaurant['name'].toLowerCase().contains(keyword.toLowerCase()) ||
                restaurant['cuisine'].toLowerCase().contains(keyword.toLowerCase()))))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName - $regionName', style: TextStyle(color: Colors.white)),
        backgroundColor: RestaurantListPage.burgundy,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: filteredRestaurants.isEmpty
          ? Center(
        child: Text('No restaurants found.', style: TextStyle(fontSize: 16)),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: filteredRestaurants.length,
        itemBuilder: (context, index) {
          return RestaurantCard(restaurant: filteredRestaurants[index], burgundy: RestaurantListPage.burgundy);
        },
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.burgundy,
  });

  final Map<String, dynamic> restaurant;
  final Color burgundy;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/restaurant-details', arguments: restaurant);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(restaurant['image'], height: 200, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(restaurant['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Text(restaurant['price'], style: TextStyle(fontSize: 16, color: burgundy)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text('${restaurant['rating']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(restaurant['address'], style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}