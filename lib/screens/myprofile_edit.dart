import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/screens/myprofile.dart';

class MyProfileEdit extends StatefulWidget {
  final User my;
  final List<User> users;
  const MyProfileEdit({super.key, required this.my, required this.users});

  @override
  State<MyProfileEdit> createState() => _MyProfileEditScreenState();
}

class _MyProfileEditScreenState extends State<MyProfileEdit> {
  late TextEditingController _nameController;
  late TextEditingController _mailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.my.name);
    _mailController = TextEditingController(text: widget.my.mail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('私のプロフィールを編集')),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(hintText: '氏名'),
                ),
                TextField(
                  controller: _mailController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(hintText: 'メールアドレス'),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc('user1')
                        .update({
                          'name': _nameController.text,
                          'mail': _mailController.text,
                        });

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            MyProfileScreen(users: widget.users),
                      ),
                    );
                  },
                  child: Text('更新'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
