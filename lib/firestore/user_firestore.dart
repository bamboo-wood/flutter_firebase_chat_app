import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('users');

  static Future<String?> createUser() async {
    try {
      final newUserDoc = await _userCollection.add(
        {
          'name': 'name',
          'imagePath': 'https://picsum.photos/300/300',
        },
      );
      return newUserDoc.id;
    } catch (e) {
      print('Failed to create account.');
      print('$e');
      return null;
    }
  }

  static Future<List<QueryDocumentSnapshot>?> fetchUsers() async {
    try {
      final snapshot = await _userCollection.get();
      for (var doc in snapshot.docs) {
        print('Document ID: ${doc.id}');
        print('Name: ${doc.data()['name']}');
      }
      return snapshot.docs;
    } catch (e) {
      print('Failed to fetch user information.');
      print('$e');
      return null;
    }
  }
}
