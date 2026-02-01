// =====================================================
// ユーティリティ関数
// =====================================================

/// 2つのユーザーIDから一意のマッチングIDを生成
///
/// IDをソートすることで、順序に関わらず同じIDを生成
/// 例: generateMatchingId('user1', 'user2') == generateMatchingId('user2', 'user1')
///
/// [userId1] ユーザーID1
/// [userId2] ユーザーID2
/// Returns: ソート済みのマッチングID（例: "user1_user2"）
String generateMatchingId(String userId1, String userId2) {
  final ids = [userId1, userId2]..sort();
  return '${ids[0]}_${ids[1]}';
}
