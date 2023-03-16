import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_app/firestore/user_firestore.dart';
import 'package:flutter_firebase_chat_app/model/talk_room.dart';
import 'package:flutter_firebase_chat_app/model/user.dart';
import 'package:flutter_firebase_chat_app/utils/shared_prefs.dart';

class RoomFireStore {
  static final FirebaseFirestore _firebaseFirestoreInstance = FirebaseFirestore.instance;
  static final _roomCollection = _firebaseFirestoreInstance.collection('rooms');
  static final joinedRoomSnapshot =
      _roomCollection.where('joined_user_ids', arrayContains: SharedPrefs.fetchUid()).snapshots();

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

  static Future<List<TalkRoom>?> fetchJoinedRooms(QuerySnapshot snapshot) async {
    List<TalkRoom> talkRooms = [];

    try {
      String? myUid = SharedPrefs.fetchUid();
      if (myUid == null) {
        throw Exception('My user ID not found.');
      }

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        TalkRoom? talkRoom = await _createTalkRoom(doc.id, data, myUid);
        if (talkRoom == null) continue;
        talkRooms.add(talkRoom);
      }

      return talkRooms;
    } catch (e) {
      print('Failed to fetch my talk rooms.');
      print('$e');
      return null;
    }
  }

  static Future<TalkRoom?> _createTalkRoom(
      String roomId, Map<String, dynamic> data, String myUid) async {
    List<dynamic> userIds = data['joined_user_ids'];
    String? talkUserUid = userIds.firstWhere((id) => id != myUid, orElse: () => null);

    if (talkUserUid == null) {
      return null;
    }

    User? talkUser = await UserFirestore.fetchProfile(talkUserUid);
    if (talkUser == null) {
      return null;
    }

    return TalkRoom(
      roomId: roomId,
      talkUser: talkUser,
      lastMessage: data['last_message'],
    );
  }

  static Stream<QuerySnapshot> fetchMessageSnapshot(String roomId) {
    return _roomCollection
        .doc(roomId)
        .collection('messages')
        .orderBy('send_time', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(String roomId, String message) async {
    try {
      final messageCollection = _roomCollection.doc(roomId).collection('messages');
      await messageCollection.add({
        'message': message,
        'sender_id': SharedPrefs.fetchUid(),
        'send_time': Timestamp.now(),
      });

      _roomCollection.doc(roomId).update({
        'last_message': message,
      });
    } catch (e) {
      print('Failed to send a message.');
      print('$e');
    }
  }
}
