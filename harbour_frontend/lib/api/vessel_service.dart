import 'package:dio/dio.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/models/token.dart';
import 'package:localstorage/localstorage.dart';

import '../models/session.dart';

class VesselService {
  final Dio dio = Dio();

  final String server = 'http://localhost:1323';

  VesselService();

  Future<List<User>> getUsers(Token jwt) async {
    try {
      final res = await dio.get('$server/restricted/getUsers',
          options: Options(headers: {'Authorization': jwt.toString()}));

      print(res.data);
      List<dynamic> data = res.data['users'];
      return data.map((userJson) => User.fromJson(userJson)).toList();
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to retrieve users'));
    }
  }
}
