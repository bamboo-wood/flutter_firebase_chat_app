import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_app/firestore/user_firestore.dart';
import 'package:flutter_firebase_chat_app/model/talk_room.dart';
import 'package:flutter_firebase_chat_app/model/user.dart';
import 'package:flutter_firebase_chat_app/utils/shared_prefs.dart';

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

  static Future<void> fetchJoinedRooms() async {
    try {
      String myUid = SharedPrefs.fetchUid()!;

      final snapshot = await _roomCollection
          .where('joined_user_ids', arrayContains: myUid)
          .get();

      List<TalkRoom> talkRooms = [];

      for (var doc in snapshot.docs) {
        List<dynamic> userIds = doc.data()['joined_user_ids'];
        late String talkUserUid;
        for (var id in userIds) {
          if (id == myUid) continue;
          talkUserUid = id;
        }
        User? talkUser = await UserFirestore.fetchProfile(talkUserUid);
        if (talkUser == null) continue;
        final talkRoom = TalkRoom(
          roomId: doc.id,
          talkUser: talkUser,
          lastMessage: doc.data()['last_message'],
        );
        talkRooms.add(talkRoom);
      }
    } catch (e) {
      print('Failed to fetch my talk rooms.');
      print('$e');
    }
  }
}
