import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/screens/myprofile.dart';
import 'package:line/screens/myprofile_edit.dart';
import 'package:line/screens/talk_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Hiragino Sans',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF55C500),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black),
      ),
      home: const BottomNavigation(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  User? _my;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc('user1')
        .get();

    final data = doc.data() as Map<String, dynamic>;
    final myWk = User(
      id: data['id'],
      name: data['name'],
      mail: data['mail'],
      profileImageUrl:
          data['profileImageUrl'] ?? 'https://picsum.photos/id/237/100/100',
    );

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: 'user1')
        .get();
    final usersWk = snapshot.docs.map((doc) {
      final data = doc.data();
      return User(
        id: data['id'],
        name: data['name'],
        profileImageUrl:
            data['profileImageUrl'] ?? 'https://picsum.photos/id/237/100/100',
      );
    }).toList();

    setState(() {
      _my = myWk;
      _users = usersWk;
    });
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      MyProfileScreen(my: _my!, users: _users),
      TalkListScreen(users: _users),
      MyProfileEdit(my: _my!),
    ];

    if (_my == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'トーク'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
      ),
    );
  }
}
