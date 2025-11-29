import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/widgets/myprofile_container.dart';
import 'package:line/widgets/talkuser_container.dart';

class MyProfileScreen extends StatefulWidget {
  final List<User> users;
  const MyProfileScreen({super.key, required this.users});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  User? _my;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc('user1')
        .get();

    final data = doc.data() as Map<String, dynamic>;
    final myWk = User(
      id: data['id'],
      name: data['name'],
      mail: data['mail'],
      profileImageUrl:
          data['profileImageUrl'] ?? 'https://picsum.photos/id/237/100/100',
    );

    setState(() {
      _my = myWk;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_my == null) {
      return Scaffold(
        appBar: AppBar(title: Text('ホーム')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '私のプロフィール',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Column(
            children: [MyprofileContainer(my: _my!, users: widget.users)],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '友達一覧（${widget.users.length}）',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          ...widget.users.map((user) {
            return TalkUserContainer(user: user);
          }),
        ],
      ),
    );
  }
}
