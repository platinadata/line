import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line/models/matching.dart';
import 'package:line/models/message.dart';

class MessageRepository {
  final FirebaseFirestore _db;
  MessageRepository(this._db);

  // MatchingIDを取得
  Future<Matching> fetchMatching(String a, String b) async {
    final ids = [a, b]..sort();
    final key = '${ids[0]}_${ids[1]}';

    final doc = await _db.collection('matching').doc(key).get();
    if (!doc.exists) throw Exception('matching not found: $key');
    return Matching.fromDoc(doc);
  }

  // メッセージを取得
  Stream<List<Message>> fetchMessages(String idMatching) {
    return _db
        .collection('messages')
        .where('idMatching', isEqualTo: idMatching)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => Message.fromMap(doc.data())).toList(),
        );
  }

  // メッセージを送信
  Future<void> sendMessage({
    required String idMatching,
    required String fromUserId,
    required String toUserId,
    required String text,
  }) async {
    final docRef = _db.collection('messages').doc();
    await docRef.set({
      'id': docRef.id,
      'idMatching': idMatching,
      'from': fromUserId,
      'to': toUserId,
      'message': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
