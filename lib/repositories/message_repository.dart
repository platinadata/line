import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line/models/message.dart';

class MessageRepository {
  final FirebaseFirestore _db;
  MessageRepository(this._db);

  // メッセージを取得
  Stream<List<Message>> fetchMessages(String roomId) {
    return _db
        .collection('messages')
        .where('roomId', isEqualTo: roomId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => Message.fromMap(doc.data())).toList(),
        );
  }

  // メッセージを送信
  Future<void> sendMessage({
    required String roomId,
    required int fromUserId,
    required int toUserId,
    required String text,
  }) async {
    final docRef = _db.collection('messages').doc();
    await docRef.set({
      'id': docRef.id,
      'roomId': roomId,
      'from': fromUserId,
      'to': toUserId,
      'message': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
