import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/widgets/talk_container.dart';

class TalkListScreen extends StatefulWidget {
  const TalkListScreen({super.key});

  @override
  State<TalkListScreen> createState() => _TalkListScreenState();
}

class _TalkListScreenState extends State<TalkListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('トーク 一覧')),
      body: Column(
        children: [
          TalkContainer(
            user: User(
              id: 1,
              name: 'masahiro',
              profileImageUrl: 'https://picsum.photos/id/237/100/100',
            ),
          ),
        ],
      ),
    );
  }
}
