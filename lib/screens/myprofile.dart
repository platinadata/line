import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/repositories/auth_repository.dart';
import 'package:line/repositories/user_repository.dart';
import 'package:line/widgets/myprofile_container.dart';
import 'package:line/widgets/talkuser_container.dart';

class MyProfileScreen extends StatefulWidget {
  final User my;
  final List<User> users;
  final AuthRepository authRepo;
  const MyProfileScreen({
    super.key,
    required this.my,
    required this.users,
    required this.authRepo,
  });

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late List<User> _filteredUsers;
  late final FirebaseFirestore _db;
  late final UserRepository _userRepo;
  @override
  void initState() {
    super.initState();
    _filteredUsers = widget.users;
    _db = FirebaseFirestore.instance;
    _userRepo = UserRepository(_db);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: ListView(
        children: [
          Column(children: [MyprofileContainer(my: widget.my)]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: TextField(
              decoration: InputDecoration(hintText: '検索'),
              onSubmitted: (String value) async {
                final results = await _userRepo.fetchSearchFriendsUsers(value);
                setState(() {
                  _filteredUsers = results;
                });
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '友だち（${widget.users.length}）',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ..._filteredUsers.map(
            (user) => TalkUserContainer(user: user, authRepo: widget.authRepo),
          ),
        ],
      ),
    );
  }
}
