import 'package:flutter/material.dart';
import 'package:line/auth/auth_repository.dart';
import 'package:line/models/message.dart';

class MessageContainer extends StatelessWidget {
  final Message message;
  final AuthRepository authRepo;
  const MessageContainer({
    super.key,
    required this.message,
    required this.authRepo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Align(
        alignment: message.from == authRepo.currentUser!.id
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          decoration: BoxDecoration(
            color: message.from == authRepo.currentUser!.id
                ? Color.lerp(const Color(0xFF55C500), Colors.white, 0.3)!
                : Color(0xFFe6e6fa),
            borderRadius: BorderRadius.all(Radius.circular(14)),
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
