import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/auth/auth_repository.dart';
import 'package:line/repositories/user_repository.dart';
import 'package:line/widgets/finduser_container.dart';

class FindFriends extends StatefulWidget {
  final AuthRepository authRepo;
  const FindFriends({super.key, required this.authRepo});

  @override
  State<FindFriends> createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriends> {
  final TextEditingController _searchController = TextEditingController();
  User? _findUser;
  bool _isSearching = false;
  late final FirebaseFirestore _db;
  late final UserRepository _userRepo;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
    _userRepo = UserRepository(_db);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ユーザー検索')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '検索',
                // バツボタン
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _findUser = null; // 検索結果をクリア
                    });
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              // Enterが押された時の処理
              onSubmitted: (String value) async {
                setState(() {
                  _isSearching = true;
                });
                final results = await _userRepo.fetchFindUser(value);
                setState(() {
                  _findUser = results;
                  _isSearching = false;
                });
              },
            ),
          ),
          if (_isSearching)
            const Center(child: CircularProgressIndicator())
          else if (_findUser == null)
            const Center(child: Text('ユーザーを検索してください'))
          else
            FindUserContainer(
              user: _findUser!,
              authRepo: widget.authRepo,
              userRepo: _userRepo,
            ),
        ],
      ),
    );
  }
}
