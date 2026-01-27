import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/message.dart';
import 'package:line/models/user.dart';
import 'package:line/auth/auth_repository.dart';
import 'package:line/repositories/message_repository.dart';
import 'package:line/screens/talk_room.dart';

class TalkUserContainer extends StatefulWidget {
  final AuthRepository authRepo;
  final User user;

  const TalkUserContainer({
    super.key,
    required this.authRepo,
    required this.user,
  });

  @override
  State<TalkUserContainer> createState() => _TalkUserContainerState();
}

class _TalkUserContainerState extends State<TalkUserContainer> {
  late final String _idMatching;
  Message? _lastMessage;
  late final FirebaseFirestore _db;
  late final MessageRepository _messageRepo;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
    _messageRepo = MessageRepository(_db);

    final ids = [widget.authRepo.currentUser!.id, widget.user.id]..sort();
    _idMatching = '${ids[0]}_${ids[1]}';

    _loadLastMessage();
  }

  Future<void> _loadLastMessage() async {
    Message? lastMessage = await _messageRepo.fetchLastMessage(_idMatching);
    if (!mounted) return;
    setState(() {
      _lastMessage = lastMessage;
    });
  }

  String _formatDay(Timestamp? createdAt) {
    if (createdAt == null) return "";
    final dt = createdAt.toDate();
    return '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final dayText = _formatDay(_lastMessage?.createdAt);
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) =>
                  TalkRoomScreen(user: widget.user, authRepo: widget.authRepo)),
            ),
          );
        },
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // アイコン
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        widget.user.profileImageUrl,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 名前とメッセージ
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _lastMessage?.message ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      dayText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
