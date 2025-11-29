class User {
  // コンストラクタ
  User({
    required this.id,
    required this.name,
    this.mail,
    required this.profileImageUrl,
  });

  // プロパティ
  final int id;
  final String name;
  final String? mail;
  final String profileImageUrl;
}
