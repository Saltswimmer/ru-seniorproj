import 'package:harbour_frontend/api/user_service.dart';
import 'package:harbour_frontend/models/vessel_model.dart';

import '../api/vessel_service.dart';
import 'token.dart';
import 'user_model.dart';

class Session {
  static bool _upToDate = false;
  static Token? _sessionToken;
  static User? _sessionUser;
  static Vessel? _sessionVessel;

  static set upToDate(bool val) {
    _upToDate = val;
  }

  static Token? get token {
    return _upToDate ? _sessionToken : null;
  }

  static User? get user {
    return _upToDate ? _sessionUser : null;
  }

  static Vessel? get vessel {
    return _upToDate ? _sessionVessel : null;
  }

  static set token(Token? token) {
    _sessionToken = token;
  }

  static set user(User? user) {
    _sessionUser = user;
  }

  static set vessel(Vessel? vessel) {
    _sessionVessel = vessel;
  }

  static Future<bool> refresh() async {
    late User user;
    try {
      user = await UserService().getUser(_sessionToken!);
      //vessel = await UserService().getVessels(_sessionToken!);
      //This is where function is going to get called when vessel is selected
    } on Exception catch (e) {
      upToDate = false;
      return false;
    }
    _sessionUser = user;
    upToDate = true;
    return true;
  }
}
