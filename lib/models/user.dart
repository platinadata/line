import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  // プロパティ
  final String id;
  final String userCode;
  final String loginId;
  final String password;
  final String name;
  final String? mail;
  final String profileImageUrl;

  // コンストラクタ
  const User({
    required this.id,
    required this.userCode,
    required this.loginId,
    required this.password,
    required this.name,
    this.mail,
    required this.profileImageUrl,
  });

  static const _defaultIcon = 'https://picsum.photos/id/237/100/100';

  factory User.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data();
    return User(
      id: doc.id,
      userCode: map['userCode'] as String,
      loginId: map['loginId'] as String,
      password: map['password'] as String,
      name: map['name'] as String,
      mail: map['mail'] as String?,
      profileImageUrl: (map['profileImageUrl'] as String?) ?? _defaultIcon,
    );
  }
}
