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

  @override
  Widget build(BuildContext context) {
    if (_my == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screens = [
      MyProfileScreen(users: _users),
      TalkListScreen(),
      MyProfileEdit(my: _my!, users: _users),
    ];
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        // タップされたタブのインデックスを設定
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        // 選択されたタブの設定（設定しないと画面は切り替わってもタブの色は変わらない）
        selectedIndex: _selectedIndex,
        // タブ自体の設定（必須項目のため、書かないとエラーになる）
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.map), label: 'Talk'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
