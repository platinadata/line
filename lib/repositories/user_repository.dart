import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line/models/user.dart';

class UserRepository {
  final FirebaseFirestore _db;
  UserRepository(this._db);

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
    // matchingテーブルから自分が関与している友だち一覧を取得
    final matchingSnap = await _db
        .collection('matching')
        .where('members', arrayContains: myDocId)
        .get();

    // 取得したデータから条件(自分側が追加している)に一致した友だちのIDを取得
    final myMatchingList = matchingSnap.docs
        .map((doc) {
          final members = (doc.data()['members'] as List)
              .whereType<String>()
              .toList();
          final add = (doc.data()['add'] as List).whereType<bool>().toList();

          // 自分の位置（membersのindex）を特定
          final myIndex = members.indexOf(myDocId);

          // 自分が追加していないならスキップ
          if (add[myIndex] != true) return null;

          // 友だちIDを返す
          for (var i = 0; i < members.length; i++) {
            if (members[i] != myDocId) return members[i];
          }
        })
        .whereType<String>()
        .toList();

    // 0件対策
    if (myMatchingList.isEmpty) {
      return [];
    }

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

  // 検索ページで検索したユーザーの情報を取得
  Future<User?> fetchFindUser(String userCode) async {
    final q = userCode.trim();
    if (q.isEmpty) return null;
    final searchFriendsSnap = await _db
        .collection('users')
        .orderBy('name')
        .startAt([q])
        .endAt(['$q\uf8ff'])
        .get();
    return User.fromDoc(searchFriendsSnap.docs.first);
  }

  // 検索ページからユーザーを追加
  Future<void> createMatching(String myDocId, String userDocId) async {
    final ids = [myDocId, userDocId]..sort();
    final idMatching = '${ids[0]}_${ids[1]}';
    final ref = _db.collection('matching').doc(idMatching);

    await _db.runTransaction((transaction) async {
      final snap = await transaction.get(ref);
      final data = snap.data();

      List<bool> add;
      List<String> members;

      if (data == null) {
        // 新規作成
        if (ids[0] == myDocId) {
          add = [true, false];
          members = [myDocId, userDocId];
        } else {
          add = [false, true];
          members = [userDocId, myDocId];
        }
      } else {
        // 既存データの更新
        add = (data['add'] as List).map((e) => e as bool).toList();
        members = (data['members'] as List).map((e) => e as String).toList();
        if (ids[0] == myDocId) {
          add[0] = true;
        } else {
          add[1] = true;
        }
      }

      transaction.set(ref, {
        'add': add,
        'members': members,
      }, SetOptions(merge: true));
    });
  }

  // 友だちかもの情報を取得
  Future<List<User>> fetchNotFriendsUsers(String myDocId) async {
    // matchingテーブルから自分が関与している友だち一覧を取得
    final matchingSnap = await _db
        .collection('matching')
        .where('members', arrayContains: myDocId)
        .get();

    // 取得したデータから条件(自分側が追加していない)に一致した友だちのIDを取得
    final myMatchingList = matchingSnap.docs
        .map((doc) {
          final members = (doc.data()['members'] as List)
              .whereType<String>()
              .toList();
          final add = (doc.data()['add'] as List).whereType<bool>().toList();

          // 自分の位置（membersのindex）を特定
          final myIndex = members.indexOf(myDocId);

          // 自分が追加しているならスキップ
          if (add[myIndex] == true) return null;

          // 友だちかもしれないのでIDを返す
          for (var i = 0; i < members.length; i++) {
            if (members[i] != myDocId) return members[i];
          }
        })
        .whereType<String>()
        .toList();

    // 0件対策
    if (myMatchingList.isEmpty) {
      return [];
    }

    // 友だちかものIDをもとにusersテーブルから友だち一覧を取得
    final friendsSnap = await _db
        .collection('users')
        .where(FieldPath.documentId, whereIn: myMatchingList)
        .get();

    return friendsSnap.docs.map((doc) => User.fromDoc(doc)).toList();
  }

  // 友だちかものユーザーを追加する
  Future<void> updateAddFlags(String a, String b) async {
    final ids = [a, b]..sort();
    final idMatching = '${ids[0]}_${ids[1]}';
    final ref = _db.collection('matching').doc(idMatching);

    final snap = await ref.get();
    final data = snap.data();
    if (data == null) return;

    final add = (data['add'] as List).map((e) => e as bool).toList();

    while (add.length < 2) add.add(false);
    add[0] = true;
    add[1] = true;

    await ref.update({'add': add});
  }
}
