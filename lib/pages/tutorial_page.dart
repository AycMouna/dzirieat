import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  static const Color burgundy = Color(0xFF800020);

  final List<Map<String, String>> tutorialSteps = [
    {
      'title': 'Choose Your Region',
      'description': 'Start by selecting your preferred region to find restaurants near you',
      'icon': 'location_on'
    },
    {
      'title': 'Select Category',
      'description': 'Browse through different restaurant categories - traditional, fast food, and more',
      'icon': 'restaurant_menu'
    },
    {
      'title': 'Explore Restaurants',
      'description': 'View detailed information about each restaurant including menu, photos, and reviews',
      'icon': 'store'
    },
    {
      'title': 'Make Your Choice',
      'description': 'Select your preferred restaurant and explore their offerings',
      'icon': 'check_circle'
    },
    {
      'title': 'Share Your Experience',
      'description': 'Rate your experience and leave reviews to help other users',
      'icon': 'star'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/couscous.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.7)),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/DZIR2.png',
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 40),
                        Text(
                          'How to Use DziriEat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        ...tutorialSteps.map((step) => buildTutorialStep(
                          step['title']!,
                          step['description']!,
                          step['icon']!,
                        )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: burgundy,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Continue to App',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTutorialStep(String title, String description, String iconName) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: burgundy.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            IconData(
              int.parse('0xe${getIconCode(iconName)}'),
              fontFamily: 'MaterialIcons',
            ),
            color: burgundy,
            size: 30,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getIconCode(String iconName) {
    Map<String, String> iconCodes = {
      'location_on': '3ab',
      'restaurant_menu': '556',
      'store': '885',
      'check_circle': '15e',
      'star': '838',
    };
    return iconCodes[iconName] ?? '56c';
  }
}