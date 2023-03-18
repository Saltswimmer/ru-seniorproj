import 'package:flutter/material.dart';
import 'dart:async';
import 'package:harbour_frontend/models/token.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/api/user_service.dart';
import 'package:harbour_frontend/routes.dart';
import 'package:localstorage/localstorage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<User> getUserInfo() async {
    late Token jwt;
    try {
      final ls = LocalStorage('harbour.json');

      jwt = Token.fromJSON(ls.getItem('access_token'));
    } catch (e) {
      return Future.error(Exception('Access token not found'));
    }

    try {
      return await UserService().getUser(jwt).timeout(
          const Duration(seconds: 15),
          onTimeout: () =>
              Future.error(Exception('Get user request timed out')));
    } on Exception catch (e) {
      return Future.error(Exception('Unable to retrive user information'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<User>(
            future: getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(child: Text("Your username is:\n${snapshot.data!.username}"));
              } else if (snapshot.hasError) {
                Future.delayed(const Duration(seconds: 5),
                    () => Routes.router.pushReplacement('/login'));
                return Text(snapshot.error.toString());
              }
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(const Size.square(80)),
                  child: const CircularProgressIndicator(
                    strokeWidth: 6.0,
                  ),
                ),
              );
            }));
  }
}
