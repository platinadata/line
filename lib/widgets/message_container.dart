import 'package:flutter/material.dart';
import 'package:line/models/message.dart';
import 'package:line/models/user.dart';

class MessageContainer extends StatelessWidget {
  final Message message;
  final User currentUser;
  const MessageContainer({
    super.key,
    required this.message,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Align(
        alignment: message.from == currentUser.id
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          decoration: const BoxDecoration(
            color: Color(0xFFe6e6fa),
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.message, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
