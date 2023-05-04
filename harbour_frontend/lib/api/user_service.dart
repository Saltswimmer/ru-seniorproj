import 'package:dio/dio.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/models/token.dart';
import 'package:harbour_frontend/models/vessel_model.dart';
import 'package:localstorage/localstorage.dart';

import '../models/session.dart';

class UserService {
  final Dio dio = Dio();

  final String server = 'http://localhost:1323';

  UserService();

  Future<void> signup(Session session, Map user) async {
    try {
      final res = await dio.post('$server/signup', data: user);
      Token jwt = Token.fromJSON(res.data);
      session.begin(jwt);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to register'));
    }
  }

  Future<void> signin(Session session, Map credentials) async {
    try {
      final res = await dio.post('$server/signin', data: credentials);
      Token jwt = Token.fromJSON(res.data);
      session.begin(jwt);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to sign in'));
    }
  }

  Future<User> getUser(Session session) async {
    try {
      final res = await dio.get('$server/user/',
          options:
              Options(headers: {'Authorization': session.token.toString()}));

      return User.fromJson(res.data);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to retrieve user'));
    }
  }

  Future<List<Vessel>?> getVessels(Session session) async {
    try {
      final res = await dio.get(
          '$server/user/getUserVessels',
          options:
              Options(headers: {'Authorization': session.token.toString()}));

      List<dynamic>? data = res.data['vessels'];
      if (data == null) {
        return null;
      }

      return data.map((vesselJson) => Vessel.fromJson(vesselJson)).toList();
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to retrieve vessels'));
    }
  }
}
