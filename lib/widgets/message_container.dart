import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/auth/auth_repository.dart';
import 'package:line/models/message.dart';

class MessageContainer extends StatelessWidget {
  final String icon;
  final Message message;
  final AuthRepository authRepo;
  const MessageContainer({
    super.key,
    required this.icon,
    required this.message,
    required this.authRepo,
  });

  String _formatTime(Timestamp createdAt) {
    final dt = createdAt.toDate();
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.from == authRepo.currentUser!.id;
    final timeText = _formatTime(message.createdAt);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(radius: 24, backgroundImage: NetworkImage(icon)),
            const SizedBox(width: 8),
          ],

          if (isMe) ...[
            Text(
              timeText,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
            const SizedBox(width: 6),
          ],

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isMe
                    ? Color.lerp(const Color(0xFF55C500), Colors.white, 0.3)!
                    : const Color(0xFFe6e6fa),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                message.message,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),

          if (!isMe) ...[
            Text(
              timeText,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}
