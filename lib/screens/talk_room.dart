import 'package:flutter/material.dart';
import 'package:line/models/user.dart';

class TalkRoomScreen extends StatefulWidget {
  final User user;
  const TalkRoomScreen({super.key, required this.user});

  @override
  State<TalkRoomScreen> createState() => _TalkRoomScreenState();
}

class _TalkRoomScreenState extends State<TalkRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name + 'さんとのトークルーム')),
      body: Column(children: [
      ],
      ),
    );
  }
}
