import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/matching.dart';
import 'package:line/models/message.dart';
import 'package:line/models/user.dart';
import 'package:line/repositories/auth_repository.dart';
import 'package:line/repositories/message_repository.dart';
import 'package:line/widgets/message_container.dart';

class TalkRoomScreen extends StatefulWidget {
  final User user;
  final AuthRepository authRepo;
  const TalkRoomScreen({super.key, required this.user, required this.authRepo});

  @override
  State<TalkRoomScreen> createState() => _TalkRoomScreenState();
}

class _TalkRoomScreenState extends State<TalkRoomScreen> {
  late final Future<Matching> _matching;
  final TextEditingController _textController = TextEditingController();
  late final FirebaseFirestore _db;
  late final MessageRepository _messageRepo;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
    _messageRepo = MessageRepository(_db);
    _matching = _messageRepo.fetchMatching(
      widget.authRepo.currentUser!.id,
      widget.user.id,
    );
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
          // メッセージ表示エリア
          Expanded(
            child: FutureBuilder<Matching>(
              future: _matching,
              builder: (context, matchingSnap) {
                if (!matchingSnap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final matching = matchingSnap.data!;

                return StreamBuilder<List<Message>>(
                  stream: _messageRepo.fetchMessages(matching.id),
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
                      itemBuilder: (_, i) => MessageContainer(
                        message: messages[i],
                        currentUser: widget.authRepo.currentUser!,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // メッセージを入力＆送信エリア
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
                    final me = widget.authRepo.currentUser!;
                    try {
                      final matching = await _matching;
                      await _messageRepo.sendMessage(
                        idMatching: matching.id,
                        fromUserId: me.id,
                        toUserId: widget.user.id,
                        text: text,
                      );
                      _textController.clear();
                    } catch (e) {
                      debugPrint('sendMessage error: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('送信に失敗しました')),
                        );
                      }
                    }
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
