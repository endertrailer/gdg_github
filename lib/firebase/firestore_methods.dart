import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(List<Map<String, dynamic>> items) async {
    try {
      await _firestore
          .collection("items")
          .doc("allItems") // You can choose any ID
          .set({"products": items});
      print('User data saved successfully');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> fetchItemsStream() {
    return _firestore.collection("items").doc("allItems").snapshots().map((
      snapshot,
    ) {
      if (snapshot.exists) {
        return List<Map<String, dynamic>>.from(
          snapshot.data()?['products'] ?? [],
        );
      } else {
        return [];
      }
    });
  }
}
