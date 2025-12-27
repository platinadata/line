import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  // プロパティ
  final String id;
  final String roomId;
  final int from;
  final int to;
  final String message;
  final Timestamp createdAt;

  // コンストラクタ
  const Message({
    required this.id,
    required this.roomId,
    required this.from,
    required this.to,
    required this.message,
    required this.createdAt,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      roomId: map['roomId'] as String,
      from: map['from'] as int,
      to: map['to'] as int,
      message: map['message'] as String,
      createdAt: map['createdAt'] as Timestamp,
    );
  }
}
