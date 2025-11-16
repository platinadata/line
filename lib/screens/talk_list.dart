import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/widgets/talkuser_container.dart';

class TalkListScreen extends StatefulWidget {
  const TalkListScreen({super.key});

  @override
  State<TalkListScreen> createState() => _TalkListScreenState();
}

class _TalkListScreenState extends State<TalkListScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc('user2')
        .get();

    final data = doc.data() as Map<String, dynamic>;

    setState(() {
      _user = User(
        id: data['id'],
        name: data['name'],
        profileImageUrl:
            data['profileImageUrl'] ?? 'https://picsum.photos/id/237/100/100',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('トーク 一覧')),
      body: Column(children: [TalkUserContainer(user: _user!)]),
    );
  }
}
