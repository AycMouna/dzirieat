import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({Key? key}) : super(key: key);

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  static const Color burgundy = Color(0xFF800020);
  double rating = 0;
  final commentController = TextEditingController();
  bool isSubmitting = false;

  Future<void> _submitReview() async {
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    if (commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a review')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final user = FirebaseAuth.instance.currentUser ;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to submit a review')),
      );
      setState(() {
        isSubmitting = false;
      });
      return;
    }

    final restaurant =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    try {
      await FirebaseFirestore.instance
          .collection('regions')
          .doc(restaurant['regionId'])
          .collection('categories')
          .doc(restaurant['categoryId'])
          .collection('restaurants')
          .doc(restaurant['id'])
          .collection('reviews')
          .add({
        'userId': user.uid,
        'rating': rating,
        'comment': commentController.text.trim(),
        'date': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context); // Go back after successful submission
    } catch (e) {
      print('Error submitting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit review. Please try again.')),
      );
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext
  context) {
  return Scaffold(
  appBar: AppBar(
  title: const Text('Add Review', style: TextStyle(color: Colors.white)),
  backgroundColor: burgundy,
  ),
  body: SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text(
  'Rating',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 8),
  Row(
  children: List.generate(
  5,
  (index) => IconButton(
  icon: Icon(
  index < rating ? Icons.star : Icons.star_border,
  color: Colors.amber,
  size: 40,
  ),
  onPressed: () {
  setState(() {
  rating = index + 1;
  });
  },
  ),
  ),
  ),
  const SizedBox(height: 16),
  const Text(
  'Your Review',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  ),
  ),
  const SizedBox(height: 8),
  TextField(
  controller: commentController,
  maxLines: 5,
  decoration: const InputDecoration(
  hintText: 'Write your review here...',
  border: OutlineInputBorder(),
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: burgundy),
  ),
  ),
  ),
  const SizedBox(height: 24),
  SizedBox(
  width: double.infinity,
  child: ElevatedButton(
  onPressed: isSubmitting ? null : _submitReview,
  style: ElevatedButton.styleFrom(
  backgroundColor: burgundy,
  foregroundColor: Colors.white,
  ),
  child: Padding(
  padding: const EdgeInsets.symmetric(vertical: 16),
  child: isSubmitting
  ? const CircularProgressIndicator(color: Colors.white)
      : const Text('Submit Review', style: TextStyle(fontSize: 18)),
  ),
  ),
  ),
  ],
  ),
  ),
  );
  }

  @override
  void dispose() {
  commentController.dispose();
  super.dispose();
  }
}