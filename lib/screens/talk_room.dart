import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/message.dart';
import 'package:line/models/user.dart';
import 'package:line/repositories/message_repository.dart';
import 'package:line/utils/room_id.dart';
import 'package:line/widgets/message_container.dart';

class TalkRoomScreen extends StatefulWidget {
  final User user;
  const TalkRoomScreen({super.key, required this.user});

  @override
  State<TalkRoomScreen> createState() => _TalkRoomScreenState();
}

class _TalkRoomScreenState extends State<TalkRoomScreen> {
  late final String _roomId;
  final TextEditingController _textController = TextEditingController();
  late final FirebaseFirestore _db;
  late final MessageRepository _messageRepo;

  @override
  void initState() {
    super.initState();
    _roomId = buildRoomId(1, widget.user.id);
    _db = FirebaseFirestore.instance;
    _messageRepo = MessageRepository(_db);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messageRepo.fetchMessages(_roomId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewInsets.bottom + 80,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (_, i) => MessageContainer(message: messages[i]),
                );
              },
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(hintText: 'メッセージを入力'),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final text = _textController.text.trim();
                    if (text.isEmpty) return;
                    try {
                      await _messageRepo.sendMessage(
                        roomId: _roomId,
                        fromUserId: 1,
                        toUserId: widget.user.id,
                        text: text,
                      );
                      _textController.clear();
                    } catch (e) {}
                  },
                  child: const Text('送信'),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
