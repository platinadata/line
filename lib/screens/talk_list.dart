import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/auth/auth_repository.dart';
import 'package:line/widgets/talkuser_container.dart';

class TalkListScreen extends StatefulWidget {
  final AuthRepository authRepo;
  final List<User> users;
  const TalkListScreen({
    super.key,
    required this.authRepo,
    required this.users,
  });

  @override
  State<TalkListScreen> createState() => _TalkListScreenState();
}

class _TalkListScreenState extends State<TalkListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('トーク 一覧')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          ...widget.users.map(
            (user) => TalkUserContainer(user: user, authRepo: widget.authRepo),
          ),
        ],
      ),
    );
  }
}
