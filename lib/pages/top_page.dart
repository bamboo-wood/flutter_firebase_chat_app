import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/model/user.dart';

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
      lastMessage: 'last message1',
    ),
    User(
      name: 'user2',
      uid: 'uid2',
      imagePath: 'https://picsum.photos/300/300',
      lastMessage: 'last message2',
    ),
    User(
      name: 'user3',
      uid: 'uid3',
      imagePath: 'https://picsum.photos/300/300',
      lastMessage: 'last message3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase Chat App'),
      ),
      body: const Center(child: Text('This screen is top page')),
    );
  }
}
