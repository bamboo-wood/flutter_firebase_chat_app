import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/model/message.dart';
import 'package:intl/intl.dart' as intl;

class TalkRoomPage extends StatefulWidget {
  final String name;
  const TalkRoomPage({super.key, required this.name});

  @override
  State<TalkRoomPage> createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  List<Message> messageList = [
    Message(
      message: 'hello',
      isMe: true,
      sendTime: DateTime(2022, 1, 1, 12, 30),
    ),
    Message(
      message: 'hi',
      isMe: false,
      sendTime: DateTime(2022, 1, 1, 12, 45),
    ),
    Message(
      message: 'how r u?',
      isMe: true,
      sendTime: DateTime(2022, 1, 1, 12, 50),
    ),
    Message(
      message:
          'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      isMe: false,
      sendTime: DateTime(2022, 1, 1, 12, 50),
    ),
    Message(
      message:
          'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      isMe: true,
      sendTime: DateTime(2022, 1, 1, 12, 50),
    ),
    Message(
      message:
          'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      isMe: false,
      sendTime: DateTime(2022, 1, 1, 12, 50),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                physics: const RangeMaintainingScrollPhysics(),
                shrinkWrap: true,
                reverse: true,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  final message = messageList[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: index == 0 ? 20 : 0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      textDirection:
                          message.isMe ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
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
                          child: Text(intl.DateFormat('HH:mm')
                              .format(message.sendTime)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              color: Colors.white,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // TODO: send
                      },
                      icon: Icon(Icons.send),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
