import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  // プロパティ
  final String id;
  final String loginId;
  final String name;
  final String? mail;
  final String profileImageUrl;

  // コンストラクタ
  const User({
    required this.id,
    required this.loginId,
    required this.name,
    this.mail,
    required this.profileImageUrl,
  });

  static const _defaultIcon = 'https://picsum.photos/id/237/100/100';

  factory User.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data();
    return User(
      id: doc.id,
      loginId: map['loginId'] as String,
      name: map['name'] as String,
      mail: map['mail'] as String?,
      profileImageUrl: (map['profileImageUrl'] as String?) ?? _defaultIcon,
    );
  }
}
