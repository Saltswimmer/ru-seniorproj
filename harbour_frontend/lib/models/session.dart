import 'package:harbour_frontend/api/user_service.dart';
import 'package:harbour_frontend/models/vessel_model.dart';

import 'token.dart';
import 'user_model.dart';

class Session {
  static bool _upToDate = false;
  static Token? _sessionToken;
  static User? _sessionUser;
  static final Map<String, Vessel> _sessionVessels = {};

  static set upToDate(bool val) {
    _upToDate = val;
  }

  static Token? get token {
    return _upToDate ? _sessionToken : null;
  }

  static User? get user {
    return _upToDate ? _sessionUser : null;
  }

  static Map<String, Vessel>? get vessels {
    return _upToDate ? _sessionVessels : null;
  }

  static set token(Token? token) {
    _sessionToken = token;
  }

  static set user(User? user) {
    _sessionUser = user;
  }

  static void addVessel(Vessel v) {
    _sessionVessels[v.vessel_id] = v;
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
}
