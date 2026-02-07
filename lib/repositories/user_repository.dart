import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line/models/user.dart';
import 'package:line/utils/id_generator.dart';

class UserRepository {
  final FirebaseFirestore _db;
  UserRepository(this._db);

  // =====================================================
  // ホームページ
  // =====================================================

  // 自分自身の情報を取得
  // ロード時に実行
  Future<User> fetchMyUser(String myLoginId) async {
    final mySnap = await _db
        .collection('users')
        .where('loginId', isEqualTo: myLoginId)
        .get();
    return User.fromDoc(mySnap.docs.first);
  }

  // 友だちの情報を取得
  // ロード時に実行
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

  // ユーザー名検索（部分一致）
  // Enterボタンクリック時に実行
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

  // =====================================================
  // 友達かもページ
  // =====================================================

  // 友だちかもの情報を取得
  // ロード時に実行
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

  // 友達追加
  // 追加ボタンクリック時に実行
  Future<void> setBothUsersAdded(String myDocId, String userDocId) async {
    final idMatching = generateMatchingId(myDocId, userDocId);
    final ref = _db.collection('matching').doc(idMatching);

    final snap = await ref.get();
    final data = snap.data();
    if (data == null) return;

    final addFlags = (data['add'] as List).map((e) => e as bool).toList();

    while (addFlags.length < 2) addFlags.add(false);
    addFlags[0] = true;
    addFlags[1] = true;

    await ref.update({'add': addFlags});
  }

  // =====================================================
  // 検索ページ
  // =====================================================

  // ユーザーコード検索（完全一致）
  // Enterボタンクリック時に実行
  Future<User?> fetchFindUser(String userCode) async {
    final q = userCode.trim();
    if (q.isEmpty) return null;
    final searchFriendsSnap = await _db
        .collection('users')
        .where('userCode', isEqualTo: q)
        .limit(1)
        .get();
    if (searchFriendsSnap.docs.isEmpty) return null;
    return User.fromDoc(searchFriendsSnap.docs.first);
  }

  // 友達追加
  // 追加ボタンクリック時に実行
  Future<void> upsertMatching(String myDocId, String userDocId) async {
    final idMatching = generateMatchingId(myDocId, userDocId);
    final ref = _db.collection('matching').doc(idMatching);

    await _db.runTransaction((transaction) async {
      final snap = await transaction.get(ref);
      final data = snap.data();

      final matchingData = data == null
          ? _createNewMatchingData(myDocId, userDocId)
          : _updateExistingMatchingData(data, myDocId, userDocId);

      transaction.set(ref, matchingData, SetOptions(merge: true));
    });
  }

  // =====================================================
  // ヘルパー
  // =====================================================

  // createMatchingのヘルパー
  // 新規マッチングデータを作成
  Map<String, dynamic> _createNewMatchingData(
    String myDocId,
    String userDocId,
  ) {
    final ids = [myDocId, userDocId]..sort();
    final isMyIdFirst = ids[0] == myDocId;

    return {
      'add': isMyIdFirst ? [true, false] : [false, true],
      'members': isMyIdFirst ? [myDocId, userDocId] : [userDocId, myDocId],
    };
  }

  // createMatchingのヘルパー
  // 既存マッチングデータを更新
  Map<String, dynamic> _updateExistingMatchingData(
    Map<String, dynamic> data,
    String myDocId,
    String userDocId,
  ) {
    final ids = [myDocId, userDocId]..sort();
    final add = (data['add'] as List).map((e) => e as bool).toList();
    final members = (data['members'] as List).map((e) => e as String).toList();

    final myIndex = ids[0] == myDocId ? 0 : 1;
    add[myIndex] = true;

    return {'add': add, 'members': members};
  }

  // =====================================================
  // プロフィールを編集ページ
  // =====================================================

  // 自分自身のプロフィールを編集
  // 更新ボタンクリック時に実行
  Future<void> editMyprofile(
    String myDocId,
    String myName,
    String myMail,
    String myuserCode,
  ) async {
    await _db.collection('users').doc(myDocId).update({
      'name': myName,
      'mail': myMail,
      'userCode': myuserCode,
    });
  }
}
