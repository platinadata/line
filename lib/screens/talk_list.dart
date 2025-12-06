import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/screens/myprofile.dart';
import 'package:line/widgets/talkuser_container.dart';

class TalkListScreen extends StatefulWidget {
  const TalkListScreen({super.key});

  @override
  State<TalkListScreen> createState() => _TalkListScreenState();
}

class _TalkListScreenState extends State<TalkListScreen> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: 'user1')
        .get();
    final usersWk = snapshot.docs.map((doc) {
      final data = doc.data();
      return User(
        id: data['id'],
        name: data['name'],
        profileImageUrl:
            data['profileImageUrl'] ?? 'https://picsum.photos/id/237/100/100',
      );
    }).toList();

    setState(() {
      _users = usersWk;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('トーク 一覧')),
      body: ListView(
        children: [
          ..._users.map((user) {
            return TalkUserContainer(user: user);
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyProfileScreen(users: _users),
                  ),
                );
              },
              child: const Text(
                '私のプロフィールを見る',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
