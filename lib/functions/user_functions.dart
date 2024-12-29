import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Import Firestore

class UserFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  // Instance of Firestore

  // Register Users with role
  Future<User?> registerUser(String email, String password) async {
    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Return the created user
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Exception: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("General Exception: $e");
      return null;
    }
  }

  // Register user with a role in Firestore
  Future<void> registerUserWithRole(String userId, String role) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'role': role,  // Save the user's role (admin or user)
        // Additional fields can be added here like email, name, etc.
      });
    } catch (e) {
      print("Error saving user role in Firestore: $e");
    }
  }

  // Login Users and fetch role
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch the user's role from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'];  // Fetch the role from Firestore

        // Return the user data and role in a map
        return {
          'uid': userCredential.user!.uid,
          'role': role,
        };
      }

      return null;  // If user doesn't exist in Firestore
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.code} - ${e.message}');
      return null; // Return null on failure
    } catch (e) {
      print('General Exception: $e');
      return null; // Return null on failure
    }
  }
}
