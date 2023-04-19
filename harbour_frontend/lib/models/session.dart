import 'package:harbour_frontend/api/user_service.dart';
import 'package:localstorage/localstorage.dart';
import 'package:harbour_frontend/routes.dart';

import 'token.dart';
import 'user_model.dart';

class Session {
  static bool _upToDate = false;
  static Token? _sessionToken;
  static User? _sessionUser;

  static set upToDate(bool val) {
    _upToDate = val;
  }

  static Token? get token {
    return _upToDate ? _sessionToken : null;
  }

  static User? get user {
    return _upToDate ? _sessionUser : null;
  }

  static set token(Token? token) {
    _sessionToken = token;
  }

  static set user(User? user) {
    _sessionUser = user;
  }

  static Future<bool> refresh() async {
    late User user;
    try {
      user = await UserService().getUser(_sessionToken!);
    } on Exception catch (e) {
      upToDate = false;
      return false;
    }
    _sessionUser = user;
    upToDate = true;
    return true;
  }

  static void logout() {
    final ls = LocalStorage('harbour.json');
    ls.deleteItem('access_token');
    upToDate = false;
    Routes.router.push('/login');
  }
}
