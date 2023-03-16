import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_app/firestore/room_firestore.dart';
import 'package:flutter_firebase_chat_app/model/user.dart';
import 'package:flutter_firebase_chat_app/utils/shared_prefs.dart';

class UserFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance = FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('users');

  static Future<String?> insertNewAccount() async {
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

  static Future<void> createUser() async {
    final myUid = await insertNewAccount();
    if (myUid != null) {
      await SharedPrefs.setUid(myUid);
      await RoomFireStore.createRoom(myUid);
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

  static Future<User?> fetchProfile(String uid) async {
    try {
      final snapshot = await _userCollection.doc(uid).get();
      User user = User(
        uid: uid,
        name: snapshot.data()!['name'],
        imagePath: snapshot.data()!['image_path'],
      );
      return user;
    } catch (e) {
      print('Failed to fetch my user information.');
      print('$e');
      return null;
    }
  }
}
