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
    return User.fromDoc(mySnap.docs.first);
  }

  // 友だちの情報を取得
  Future<List<User>> fetchFriendsUsers(String myDocId) async {
    // matchingテーブルから友だち一覧を取得
    final matchingSnap = await _db
        .collection('matching')
        .where('members', arrayContains: myDocId)
        .get();
    // 取得したデータから友だちのIDを取得
    final myMatchingList = matchingSnap.docs
        .map((doc) {
          final members = (doc.data()['members'] as List)
              .whereType<String>()
              .toList();
          for (final id in members) {
            if (id != myDocId) return id;
          }
          return null;
        })
        .whereType<String>()
        .toList();
    // 友だちのIDをもとにusersテーブルから友だち一覧を取得
    final friendsSnap = await _db
        .collection('users')
        .where(FieldPath.documentId, whereIn: myMatchingList)
        .get();
    return friendsSnap.docs.map((doc) => User.fromDoc(doc)).toList();
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
    return searchFriendsSnap.docs.map((doc) => User.fromDoc(doc)).toList();
  }
}
