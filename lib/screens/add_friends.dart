import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/repositories/auth_repository.dart';
import 'package:line/repositories/user_repository.dart';
import 'package:line/widgets/adduser_container.dart';

class AddFriends extends StatefulWidget {
  final AuthRepository authRepo;
  const AddFriends({super.key, required this.authRepo});

  @override
  State<AddFriends> createState() => _MyProfileEditScreenState();
}

class _MyProfileEditScreenState extends State<AddFriends> {
  List<User>? _notAddUsers;
  late final FirebaseFirestore _db;
  late final UserRepository _userRepo;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
    _userRepo = UserRepository(_db);
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    // 友だちの情報を取得
    final notAddUsers = await _userRepo.fetchNotFriendsUsers(
      widget.authRepo.currentUser!.id,
    );

    setState(() {
      _notAddUsers = notAddUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final users = _notAddUsers;

    if (users == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (users.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('友だちかも')),
        body: const Center(child: Text('現在友だちかもしれないユーザーはいません')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('友だちかも')),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 40),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return AddUserContainer(
            user: users[index],
            authRepo: widget.authRepo,
            userRepo: _userRepo,
          );
        },
      ),
    );
  }
}
