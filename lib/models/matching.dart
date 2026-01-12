import 'package:cloud_firestore/cloud_firestore.dart';

class Matching {
  // プロパティ
  final String id;
  final List<String> members;

  // コンストラクタ
  const Matching({required this.id, required this.members});

  factory Matching.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Matching document not found: ${doc.reference.path}');
    }
    return Matching.fromMap(data, doc.id);
  }

  factory Matching.fromMap(Map<String, dynamic> map, String id) {
    return Matching(
      id: id,
      members: (map['members'] as List<dynamic>).cast<String>(),
    );
  }
}
