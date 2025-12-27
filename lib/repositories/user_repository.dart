import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line/models/user.dart';

class UserRepository {
  UserRepository(this._db);
  final FirebaseFirestore _db;

  // 自分自身の情報を取得
  Future<User> fetchMyUser(String myId) async {
    final mySnap = await _db.collection('users').doc(myId).get();
    return User.fromMap(mySnap.data() ?? const {});
  }

  // 友だちの情報を取得
  Future<List<User>> fetchFriendsUsers(String myId) async {
    final friendsSnap = await _db
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: myId)
        .get();
    return friendsSnap.docs.map((doc) => User.fromMap(doc.data())).toList();
  }

  // 検索した友だちの情報を取得
  Future<List<User>> fetchSearchFriendsUsers(String keyword) async {
    final q = keyword.trim();
    if (q.isEmpty) return [];
    final searchFriendsSnap = await _db
        .collection('users')
        .orderBy('name')
        .startAt([q])
        .endAt(['$q\uf8ff'])
        .get();
    return searchFriendsSnap.docs
        .map((doc) => User.fromMap(doc.data()))
        .toList();
  }
}
