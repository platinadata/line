import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line/models/user.dart';

class UserRepository {
  UserRepository(this._db);
  final FirebaseFirestore _db;

  // 自分自身の情報を取得
  Future<User> fetchMyUser(String myLoginId) async {
    final mySnap = await _db
        .collection('users')
        .where('loginId', isEqualTo: myLoginId)
        .get();
    return User.fromMap(mySnap.docs.first.data());
  }

  // 友だちの情報を取得
  Future<List<User>> fetchFriendsUsers(int myId) async {
    // matchingテーブルから友だち一覧を取得
    final matchingSnap = await _db
        .collection('matching')
        .where('members', arrayContains: myId)
        .get();
    // 取得したデータから友だちのIDを取得
    final myMatchingList = matchingSnap.docs
        .map((doc) {
          final members = (doc.data()['members'] as List<dynamic>?)
              ?.cast<int?>();
          if (members == null) return null;

          return members.firstWhere((id) => id != myId, orElse: () => null);
        })
        .whereType<int>()
        .toList();
    // 友だちのIDをもとにusersテーブルから友だち一覧を取得
    final friendsSnap = await _db
        .collection('users')
        .where('id', whereIn: myMatchingList)
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
