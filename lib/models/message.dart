class Message {
  // コンストラクタ
  Message({
    required this.id,
    required this.idMatching,
    required this.from,
    required this.to,
    required this.message,
  });

  // プロパティ
  final int id;
  final int idMatching;
  final int from;
  final int to;
  final String message;
}
