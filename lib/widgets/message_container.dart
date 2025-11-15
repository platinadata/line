import 'package:flutter/material.dart';
import 'package:line/models/message.dart';

class MessageContainer extends StatelessWidget {
  final Message message;
  const MessageContainer({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Align(
        alignment: message.idUserFrom == 1
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          decoration: const BoxDecoration(
            color: Color(0xFFe6e6fa),
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.word,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
