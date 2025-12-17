import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  // コンストラクタ
  Message({
    required this.id,
    required this.roomId,
    required this.from,
    required this.to,
    required this.message,
    required this.createdAt,
  });

  // プロパティ
  final String id;
  final String roomId;
  final int from;
  final int to;
  final String message;
  final Timestamp createdAt;
}
