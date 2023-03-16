import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('users');

  static Future<void> createUser() async {
    try {
      await _userCollection.add(
        {
          'name': 'name',
          'imagePath': 'https://picsum.photos/300/300',
        },
      );
    } catch (e) {
      print('Failed to create account.');
      print('$e');
    }
  }

  static Future<void> fetchUsers() async {
    try {
      final snapshot = await _userCollection.get();
      for (var doc in snapshot.docs) {
        print('Document ID: ${doc.id}');
        print('Name: ${doc.data()['name']}');
      }
    } catch (e) {
      print('Failed to fetch user information.');
      print('$e');
    }
  }
}
