// services/base_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class BaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }

  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collection, String docId) async {
    await _firestore.collection(collection).doc(docId).delete();
  }

  Stream<QuerySnapshot> getDocumentsStream(String collection) {
    return _firestore.collection(collection).snapshots();
  }
}