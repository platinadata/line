class User {
  // プロパティ
  final int id;
  final String name;
  final String? mail;
  final String profileImageUrl;

  // コンストラクタ
  const User({
    required this.id,
    required this.name,
    this.mail,
    required this.profileImageUrl,
  });

  static const _defaultIcon = 'https://picsum.photos/id/237/100/100';

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      mail: map['mail'] as String?,
      profileImageUrl: (map['profileImageUrl'] as String?) ?? _defaultIcon,
    );
  }
}
