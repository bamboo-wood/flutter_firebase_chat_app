import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_app/firestore/user_firestore.dart';

class RoomFireStore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _roomCollection = _firebaseFirestoreInstance.collection('rooms');

  static Future<void> createRoom(String myUid) async {
    try {
      final usersSnapshot = await UserFirestore.fetchUsers();
      if (usersSnapshot == null) return;

      for (var userSnapshot in usersSnapshot) {
        if (userSnapshot.id == myUid) continue;
        await _roomCollection.add({
          'joined_user_ids': [userSnapshot.id, myUid],
          'created_time': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Failed to create talk room.');
      print('$e');
    }
  }
}
