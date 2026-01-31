import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/auth/auth_repository.dart';
import 'package:line/repositories/user_repository.dart';
import 'package:line/screens/add_friends.dart';
import 'package:line/screens/find_friends.dart';
import 'package:line/widgets/myfrienduser_container.dart';
import 'package:line/widgets/myprofile_container.dart';

class MyProfileScreen extends StatefulWidget {
  final AuthRepository authRepo;
  final List<User> users;
  const MyProfileScreen({
    super.key,
    required this.authRepo,
    required this.users,
  });

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<User> _filteredUsers;
  late int _filteredUsersLength;
  late final FirebaseFirestore _db;
  late final UserRepository _userRepo;
  @override
  void initState() {
    super.initState();
    _filteredUsers = widget.users;
    _filteredUsersLength = widget.users.length;
    _db = FirebaseFirestore.instance;
    _userRepo = UserRepository(_db);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.add_reaction_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) =>
                          AddFriends(authRepo: widget.authRepo)),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.search_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) =>
                          FindFriends(authRepo: widget.authRepo)),
                    ),
                  );
                },
              ),
            ],
          ),
          Column(children: [MyprofileContainer(authRepo: widget.authRepo)]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '検索',
                // バツボタン
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _filteredUsers = widget.users;
                      _filteredUsersLength = widget.users.length;
                    });
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              // Enterが押された時の処理
              onSubmitted: (String value) async {
                final results = await _userRepo.fetchSearchFriendsUsers(value);
                setState(() {
                  _filteredUsers = results;
                  _filteredUsersLength = results.length;
                });
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '友だち（$_filteredUsersLength）',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ..._filteredUsers.map(
            (user) =>
                MyFriendUserContainer(user: user, authRepo: widget.authRepo),
          ),
        ],
      ),
    );
  }
}
