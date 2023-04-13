import 'package:dio/dio.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/models/token.dart';
import 'package:localstorage/localstorage.dart';

import '../models/session.dart';

class UserService {
  final Dio dio = Dio();

  final String server = 'http://localhost:1323';

  UserService();

  Future<void> signup(Map user) async {
    try {
      final res = await dio.post('$server/signup', data: user);
      Token jwt = Token.fromJSON(res.data);
      _beginSession(jwt);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to register'));
    }
  }

  Future<void> signin(Map credentials) async {
    try {
      final res = await dio.post('$server/signin', data: credentials);
      Token jwt = Token.fromJSON(res.data);
      _beginSession(jwt);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to sign in'));
    }
  }

  Future<User> getUser(Token jwt) async {
    try {
      final res = await dio.get('$server/restricted/user',
          options:
              Options(headers: {'Authorization': jwt.toString()}));

      return User.fromJson(res.data);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to retrieve user'));
    }
  }

  void _beginSession(Token jwt) async {
    try {
      final ls = LocalStorage('harbour.json');
      //print(jwt.accessToken);
      ls.setItem('access_token', jwt);

      Session.token = jwt;
      Session.user = await getUser(jwt);
      Session.upToDate = true;
    } catch (e) {
      print(e.toString());
      Session.upToDate = false;
    }
  }
}
