import 'package:dio/dio.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/models/token.dart';

class UserService {
  final Dio dio = Dio();

  UserService();

  Future<User> getUser(Token jwt) async {
    try {
      final res =
          await dio.get('http://localhost:1323/user', data: jwt.toJson());

      return User.fromJson(res.data);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to retrieve user'));
    }
  }

  Future<Token> signup(Map user) async {
    try {
      final res = await dio.post('http://localhost:1323/signup', data: user);
      return Token.fromJSON(res.data);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to register'));
    }
  }
}
