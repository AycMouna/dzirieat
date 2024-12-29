import 'package:dzirieat_app/pages/restaurant_menu_page.dart';
import 'package:dzirieat_app/pages/tutorial_page.dart';
import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'pages/admin_login_page.dart';
import 'pages/add_review_page.dart';
import 'pages/admin_panel_page.dart';
import 'pages/restaurant_detail_page.dart';
import 'pages/restaurant_list_page.dart';
import 'pages/home_page.dart';
import 'pages/auth_page.dart';
import 'pages/category_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'pages/registration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAim9AQpZupFAFURR5modE8gqb7AuzAcKg",
          authDomain: "dzirieat-e36de.firebaseapp.com",
          projectId: "dzirieat-e36de",
          storageBucket: "dzirieat-e36de.firebasestorage.app",
          messagingSenderId: "632982471203",
          appId: "1:632982471203:web:c5efc79bcb31f461e26796",
          measurementId: "G-X8TGH9JR4K"));}

  else {
  await Firebase.initializeApp();}

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const Color burgundy = Color(0xFF800020);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: burgundy,
        primarySwatch: MaterialColor(
          burgundy.value,
          <int, Color>{
            50: Color(0xFFF2E2E6),
            100: Color(0xFFDEB6C0),
            200: Color(0xFFC98596),
            300: Color(0xFFB3546C),
            400: Color(0xFFA2304D),
            500: Color(0xFF800020),
            600: Color(0xFF78001D),
            700: Color(0xFF6D0018),
            800: Color(0xFF630014),
            900: Color(0xFF50000B),
          },
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: burgundy,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: burgundy,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/': (context) => AuthPage(),
        '/tuto': (context) => TutorialPage(),
        '/register': (context) => RegistrationPage(),
        '/adminLogin': (context) => AdminLoginPage(),
        '/adminPanel': (context) => AdminPanelPage(),
        '/home': (context) => HomePage(),
        '/category': (context) => CategoryPage(),
        '/restaurant-list': (context) => RestaurantListPage(),
        '/restaurant-details': (context) => RestaurantDetailsPage(),
        '/add-review': (context) => AddReviewPage(),
        '/menu': (context) => MenuPage(),
      },
    );
  }
}