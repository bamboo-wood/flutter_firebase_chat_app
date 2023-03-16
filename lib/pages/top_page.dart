import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/firestore/room_firestore.dart';
import 'package:flutter_firebase_chat_app/model/talk_room.dart';
import 'package:flutter_firebase_chat_app/pages/setting_profile_page.dart';
import 'package:flutter_firebase_chat_app/pages/talk_room_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase Chat App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingProfilePage(),
                  ));
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: RoomFireStore.joinedRoomSnapshot,
          builder: (context, streamSnapshot) {
            if (streamSnapshot.hasData) {
              return FutureBuilder(
                future: RoomFireStore.fetchJoinedRooms(streamSnapshot.data!),
                builder: (context, futureSnapshot) {
                  if (futureSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!futureSnapshot.hasData) {
                    return const Center(child: Text('No talk rooms.'));
                  }
                  List<TalkRoom> talkRooms = futureSnapshot.data!;
                  return TalkRoomList(talkRooms: talkRooms);
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class TalkRoomList extends StatelessWidget {
  const TalkRoomList({
    super.key,
    required this.talkRooms,
  });

  final List<TalkRoom> talkRooms;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: talkRooms.length,
      itemBuilder: (context, index) {
        final talkRoom = talkRooms[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TalkRoomPage(
                  talkRoom: talkRoom,
                ),
              ),
            );
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: talkRoom.talkUser.imagePath == null
                      ? null
                      : NetworkImage(talkRoom.talkUser.imagePath!),
                  child: talkRoom.talkUser.imagePath == null
                      ? const Icon(Icons.account_circle, size: 50)
                      : null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    talkRoom.talkUser.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    talkRoom.lastMessage ?? '',
                    style: const TextStyle(
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
