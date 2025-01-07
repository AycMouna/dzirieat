import 'package:dzirieat_app/pages/auth/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:dzirieat_app/pages/auth/splash_screen.dart';
import 'package:dzirieat_app/pages/auth/auth_page.dart';
import 'package:dzirieat_app/pages/auth/registration_page.dart';
import 'package:dzirieat_app/pages/auth/tutorial_page.dart';
import 'package:dzirieat_app/pages/auth/admin_login_page.dart';
import 'package:dzirieat_app/pages/admin/admin_panel_page.dart';
import 'package:dzirieat_app/pages/restaurant/restaurant_list_page.dart';
import 'package:dzirieat_app/pages/restaurant/restaurant_detail_page.dart';
import 'package:dzirieat_app/pages/restaurant/add_review_page.dart';
import 'package:dzirieat_app/pages/category_page.dart';
import 'package:dzirieat_app/pages/restaurant/restaurant_menu_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAim9AQpZupFAFURR5modE8gqb7AuzAcKg",
        authDomain: "dzirieat-e36de.firebaseapp.com",
        projectId: "dzirieat-e36de",
        storageBucket: "dzirieat-e36de.firebasestorage.app",
        messagingSenderId: "632982471203",
        appId: "1:632982471203:web:c5efc79bcb31f461e26796",
        measurementId: "G-X8TGH9JR4K",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const Color burgundy = Color(0xFF800020);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DziriEat',
      debugShowCheckedModeBanner: false,
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
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: burgundy,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        if (settings.name == '/menu') {
          // Extract the arguments passed to this route
          final args = settings.arguments as Map<String, dynamic>;

          // Return MaterialPageRoute for MenuPage with the restaurant data
          return MaterialPageRoute(
            builder: (context) => MenuPage(restaurant: args),
            settings: settings,
          );
        }

        // Handle other routes
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => SplashScreen());
          case '/':
            return MaterialPageRoute(builder: (_) => AuthPage());
          case '/tuto':
            return MaterialPageRoute(builder: (_) => TutorialPage());
          case '/register':
            return MaterialPageRoute(builder: (_) => RegistrationPage());
          case '/adminLogin':
            return MaterialPageRoute(builder: (_) => AdminLoginPage());
          case '/adminPanel':
            return MaterialPageRoute(builder: (_) => AdminPanelPage());
          case '/home':
            return MaterialPageRoute(builder: (_) => HomePage());
          case '/category':
            return MaterialPageRoute(builder: (_) => CategoryPage());

          case '/restaurant-list':
            return MaterialPageRoute(builder: (_) => RestaurantListPage());
          case '/restaurant-details':
            return MaterialPageRoute(
              builder: (_) => RestaurantDetailsPage(),
              settings: settings,
            );
          case '/add-review':
            return MaterialPageRoute(builder: (_) => AddReviewPage());
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text('Route ${settings.name} not found'),
                ),
              ),
            );
        }
      },
    );
  }
}
