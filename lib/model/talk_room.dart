import 'package:flutter_firebase_chat_app/model/user.dart';

class TalkRoom {
  String roomId;
  User talkUser;
  String? lastMessage;

  TalkRoom({
    required this.roomId,
    required this.talkUser,
    this.lastMessage,
  });
}
