import 'package:dio/dio.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/models/token.dart';
import 'package:harbour_frontend/models/vessel_model.dart';
import 'package:localstorage/localstorage.dart';

import '../models/session.dart';

class VesselService {
  final Dio dio = Dio();

  final String server = 'http://localhost:1323';

  VesselService();

  Future<List<User>> getUsers(Token jwt) async {
    try {
      final res = await dio.get('$server/vessel/members',
          options: Options(headers: {'Authorization': jwt.toString()}));

      print(res.data);
      List<dynamic> data = res.data['users'];
      return data.map((userJson) => User.fromJson(userJson)).toList();
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to retrieve users'));
    }
  }

  Future<List<Vessel>> search(String name, Token jwt) async {
    try {
      final res = await dio.get('$server/vessel/search',
          data: {'vessel_name': name},
          options: Options(headers: {'Authorization': jwt.toString()}));

      return (res.data['vessels'] as List<Map<dynamic, dynamic>>)
          .map((e) => Vessel.fromJson(e))
          .toList();
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Search failed'));
    }
  }

  Future<Vessel> createVessel(Token jwt, String name) async {
    try {
      final res = await dio.post('$server/vessel/new',
          data: {'name': name},
          options: Options(headers: {'Authorization': jwt.toString()}));

      print(res);
      return Vessel.fromJson(res.data);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to create vessel'));
    }
  }
}
