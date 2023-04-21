import 'package:flutter/material.dart';
import 'package:harbour_frontend/api/user_service.dart';
import 'package:harbour_frontend/models/vessel_model.dart';
import 'package:localstorage/localstorage.dart';

import 'token.dart';
import 'user_model.dart';

class Session extends ChangeNotifier {
  bool _upToDate = false;
  bool _lock = true;
  Token? _sessionToken;
  User? _sessionUser;
  Vessel? _sessionCurrentVessel;
  final Map<String, Vessel> _sessionVessels = {};

  bool get lock {
    return _lock;
  }

  set upToDate(bool val) {
    _upToDate = val;
  }

  Token? get token {
    return _upToDate ? _sessionToken : null;
  }

  User? get user {
    return _upToDate ? _sessionUser : null;
  }

  Vessel? get currentVessel {
    return _upToDate ? _sessionCurrentVessel : null;
  }

  Map<String, Vessel>? get vessels {
    return _upToDate ? _sessionVessels : null;
  }

  set token(Token? token) {
    _sessionToken = token;
    notifyListeners();
  }

  set user(User? user) {
    _sessionUser = user;
    notifyListeners();
  }

  set currentVessel(Vessel? vessel) {
    _sessionCurrentVessel = vessel;
    notifyListeners();
  }

  void addVessel(Vessel v) {
    _sessionVessels[v.vessel_id] = v;
    notifyListeners();
  }

  void begin(Token jwt) async {
    try {
      final ls = LocalStorage('harbour.json');
      final UserService u = UserService();
      //print(jwt.accessToken);
      ls.setItem('access_token', jwt);

      _upToDate = true;
      _sessionToken = jwt;
      _sessionUser = await u.getUser(this);
      List<Vessel>? vessels = await u.getVessels(this);
      if (vessels != null) {
        for (Vessel v in vessels) {
          addVessel(v);
        }
      }
      _lock = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      _upToDate = false;
      _lock = true;
      notifyListeners();
    }
  }

  void wipe() {
    _upToDate = false;
    _lock = true;
    _sessionToken = null;
    _sessionUser = null;
    _sessionCurrentVessel = null;
    _sessionVessels.clear();
    notifyListeners();
  }

  Future<bool> refresh() async {
    late User user;
    try {
      user = await UserService().getUser(this);
      print(user);
    } on Exception catch (e) {
      upToDate = false;
      notifyListeners();
      return false;
    }
    _sessionUser = user;
    upToDate = true;
    notifyListeners();
    return true;
  }
}
