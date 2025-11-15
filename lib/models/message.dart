class Message {
  // コンストラクタ
  Message({
    required this.id,
    required this.idMatching,
    required this.word,
    required this.idUserTo,
    required this.idUserFrom,
  });

  // プロパティ
  final int id;
  final int idMatching;
  final int idUserTo;
  final int idUserFrom;
  final String word;
}
