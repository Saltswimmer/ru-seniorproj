import 'package:dio/dio.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/models/token.dart';

class UserService {
  final Dio dio = Dio();

  final String server = 'http://localhost:1323';

  UserService();

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

  Future<Token> signup(Map user) async {
    try {
      final res = await dio.post('$server/signup', data: user);
      return Token.fromJSON(res.data);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to register'));
    }
  }

  Future<Token> signin(Map credentials) async {
    try {
      final res = await dio.post('$server/signin', data: credentials);
      return Token.fromJSON(res.data);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to sign in'));
    }
  }
}
