import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/firestore/room_firestore.dart';
import 'package:flutter_firebase_chat_app/model/message.dart';
import 'package:flutter_firebase_chat_app/model/talk_room.dart';
import 'package:flutter_firebase_chat_app/utils/shared_prefs.dart';
import 'package:intl/intl.dart' as intl;

class TalkRoomPage extends StatefulWidget {
  final TalkRoom talkRoom;
  const TalkRoomPage({super.key, required this.talkRoom});

  @override
  State<TalkRoomPage> createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.talkRoom.talkUser.name),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: RoomFireStore.fetchMessageSnapshot(widget.talkRoom.roomId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No message.'));
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: ListView.builder(
                      physics: const RangeMaintainingScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        Message message = Message(
                          message: data['message'],
                          isMe: SharedPrefs.fetchUid() == data['sender_id'],
                          sendTime: data['send_time'],
                        );

                        return Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 10,
                            right: 10,
                            bottom: index == 0 ? 20 : 0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            textDirection: message.isMe ? TextDirection.rtl : TextDirection.ltr,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.6),
                                decoration: BoxDecoration(
                                  color: message.isMe
                                      ? Colors.lightGreen
                                      : const Color.fromARGB(255, 220, 220, 220),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                child: Text(message.message),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(intl.DateFormat('HH:mm').format(
                                  message.sendTime.toDate(),
                                )),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.white,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: messageController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (messageController.text.isEmpty) return;
                            await RoomFireStore.sendMessage(
                              widget.talkRoom.roomId,
                              messageController.text,
                            );
                            messageController.clear();
                          },
                          icon: const Icon(Icons.send),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
