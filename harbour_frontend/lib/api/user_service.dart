import 'package:dio/dio.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/models/token.dart';

class UserService {
  final String usersURL = 'http://localhost:5000/users';
  final Dio dio = Dio();

  UserService();

  Future<List<User>> getUsers() async {
    late List<User> users;
    try {
      final res = await dio.get(usersURL);

      users = res.data['users']
          .map<User>(
            (item) => User.fromJson(item),
          )
          .toList();
    } on DioError catch (e) {
      users = [];
    }

    return users;
  }

  Future<Token> signup(Map user) async {
    try {
      final res = await dio.post('http://localhost:1323/signup', data: user);
      return Token.fromJSON(res.data);
    } on DioError catch (e) {
      print(e.message);
      return const Token(accessToken: null, tokenType: null);
    }
  }
}
