import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  // プロパティ
  final String id;
  final String idMatching;
  final String from;
  final String to;
  final String message;
  final Timestamp createdAt;

  // コンストラクタ
  const Message({
    required this.id,
    required this.idMatching,
    required this.from,
    required this.to,
    required this.message,
    required this.createdAt,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      idMatching: map['idMatching'] as String,
      from: map['from'] as String,
      to: map['to'] as String,
      message: map['message'] as String,
      createdAt: map['createdAt'] as Timestamp,
    );
  }
}
