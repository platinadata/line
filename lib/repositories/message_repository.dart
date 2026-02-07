import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line/models/message.dart';
import 'package:line/utils/id_generator.dart';

class MessageRepository {
  final FirebaseFirestore _db;
  MessageRepository(this._db);

  // =====================================================
  // トーク一覧ページ
  // =====================================================
  // 最後のメッセージを取得
  // ロード時に実行
  Future<Message?> fetchLastMessage(String myDocId, String userDocId) async {
    final snap = await _db
        .collection('messages')
        .where('idMatching', isEqualTo: generateMatchingId(myDocId, userDocId))
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;

    final data = snap.docs.first.data();
    return Message.fromMap(data);
  }

  // =====================================================
  // トークルームページ
  // =====================================================
  // メッセージを取得
  // ロード時に実行
  Stream<List<Message>> fetchMessages(String myDocId, String userDocId) {
    return _db
        .collection('messages')
        .where('idMatching', isEqualTo: generateMatchingId(myDocId, userDocId))
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => Message.fromMap(doc.data())).toList(),
        );
  }

  // メッセージを送信
  // 送信ボタンクリック時に実行
  Future<void> sendMessage({
    required String fromUserId,
    required String toUserId,
    required String text,
  }) async {
    final docRef = _db.collection('messages').doc();
    await docRef.set({
      'id': docRef.id,
      'idMatching': generateMatchingId(fromUserId, toUserId),
      'from': fromUserId,
      'to': toUserId,
      'message': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
