import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/message.dart';
import 'package:line/models/user.dart';
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

  @override
  void initState() {
    super.initState();
    _roomId = buildRoomId(1, widget.user.id);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.user.name}さんとのトークルーム')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('roomId', isEqualTo: _roomId)
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return MessageContainer(
                      message: Message(
                        id: data['id'],
                        roomId: data['roomId'],
                        from: data['from'],
                        to: data['to'],
                        message: data['message'],
                        createdAt: data['createdAt'],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const Spacer(),
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
                    final text = _textController.text;
                    if (text.isEmpty) return;

                    final collection = FirebaseFirestore.instance.collection(
                      'messages',
                    );
                    final docRef = collection.doc();

                    await docRef.set({
                      'id': docRef.id,
                      'roomId': _roomId,
                      'from': 1,
                      'to': widget.user.id,
                      'message': text,
                      'createdAt': Timestamp.now(),
                    });

                    _textController.clear();
                  },
                  child: const Text('送信'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
