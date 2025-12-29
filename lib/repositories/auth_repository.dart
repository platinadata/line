import 'package:line/models/user.dart';

class AuthRepository {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setCurrentUser(User user) {
    _currentUser = user;
  }

  void clear() {
    _currentUser = null;
  }
}
