import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/widgets/myprofile_container.dart';
import 'package:line/widgets/talkuser_container.dart';

class MyProfileScreen extends StatefulWidget {
  final User my;
  final List<User> users;
  const MyProfileScreen({super.key, required this.my, required this.users});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: ListView(
        children: [
          Column(children: [MyprofileContainer(my: widget.my)]),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '友だち（${widget.users.length}）',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ...widget.users.map((user) => TalkUserContainer(user: user)),
        ],
      ),
    );
  }
}
