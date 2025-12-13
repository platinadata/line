class Message {
  // コンストラクタ
  Message({
    required this.id,
    required this.roomId,
    required this.from,
    required this.to,
    required this.message,
  });

  // プロパティ
  final int id;
  final String roomId;
  final int from;
  final int to;
  final String message;
}
