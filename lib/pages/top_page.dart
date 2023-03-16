import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/model/user.dart';
import 'package:flutter_firebase_chat_app/pages/setting_profile_page.dart';
import 'package:flutter_firebase_chat_app/pages/talk_room_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<User> userList = [
    User(
      name: 'user1',
      uid: 'uid1',
      imagePath: 'https://picsum.photos/300/300',
    ),
    User(
      name: 'user2',
      uid: 'uid2',
      imagePath: 'https://picsum.photos/300/300',
    ),
    User(
      name: 'user3',
      uid: 'uid3',
    ),
  ];

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
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TalkRoomPage(
                    name: user.name,
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
                    backgroundImage: user.imagePath == null
                        ? null
                        : NetworkImage(user.imagePath!),
                    child: user.imagePath == null
                        ? const Icon(Icons.account_circle, size: 50)
                        : null,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'user.lastMessage',
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
      ),
    );
  }
}
