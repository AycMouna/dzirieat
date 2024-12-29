import 'package:flutter/material.dart';
import 'package:arabic_font/arabic_font.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color burgundy = Color(0xFF800020);

  void _navigateToAuth() {
    Navigator.pushReplacementNamed(context, '/tuto');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _navigateToAuth,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset(
              'assets/images/splash_bg.jpg',
              fit: BoxFit.cover,
            ),
            // Dark Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    burgundy.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/DZIR2.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 24),
                  // App Name
                  Text(
                    'DZIRIEAT',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Subtitle
                  Text(
                    'ALGERIAN RESTAURANT',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(height: 48),
                  // Arabic Text using ArabicFont
                  Text(
                    'تعرف على المطبخ الجزائري',
                    style: ArabicTextStyle(
                      arabicFont: ArabicFont.amiri,
                      fontSize: 24,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 32),
                  // Tap indication text
                  Text(
                    'Tap anywhere to continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}