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

  Future<Token> addUser(Map user) async {
    late Token token;

    try {
      final res =
          await dio.put('http://localhost:5000/addUser', data: user);

      token = Token.fromBase64(res.data['addUser']);
    } on DioError catch (e) {
      print(e.message);
      token = const Token(header: {}, payload: {}, signature: {});
    }

    return token;
  }
}
