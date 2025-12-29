import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line/models/user.dart';
import 'package:line/repositories/user_repository.dart';
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
      home: const AppHomePage(),
    );
  }
}

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  User? _my;
  List<User> _friends = [];
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
    const myLoginId = 'masahiro.517';

    // 自分自身の情報を取得
    final my = await _userRepo.fetchMyUser(myLoginId);

    // 友だちの情報を取得
    final friends = await _userRepo.fetchFriendsUsers(my.id);

    setState(() {
      _my = my;
      _friends = friends;
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
    if (_my == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screens = [
      MyProfileScreen(my: _my!, users: _friends),
      TalkListScreen(users: _friends),
      MyProfileEdit(my: _my!),
    ];

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
