import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/message.dart';
import 'package:line/models/user.dart';
import 'package:line/auth/auth_repository.dart';
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
  late final String _idMatching;
  final TextEditingController _textController = TextEditingController();
  late final FirebaseFirestore _db;
  late final MessageRepository _messageRepo;
  late final Stream<List<Message>> _messagesStream;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
    _messageRepo = MessageRepository(_db);
    final ids = [widget.authRepo.currentUser!.id, widget.user.id]..sort();
    _idMatching = '${ids[0]}_${ids[1]}';
    _messagesStream = _messageRepo.fetchMessages(_idMatching);
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
            child: StreamBuilder<List<Message>>(
              stream: _messagesStream,
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
                    icon: widget.user.profileImageUrl,
                    message: messages[i],
                    authRepo: widget.authRepo,
                  ),
                );
              },
            ),
          ),
          // メッセージを入力＆送信エリア
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(hintText: 'メッセージを入力'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final text = _textController.text.trim();
                    if (text.isEmpty) return;
                    try {
                      await _messageRepo.sendMessage(
                        idMatching: _idMatching,
                        fromUserId: widget.authRepo.currentUser!.id,
                        toUserId: widget.user.id,
                        text: text,
                      );
                      _textController.clear();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('送信に失敗しました')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.send, size: 32),
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
