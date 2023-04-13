import 'package:flutter/material.dart';
import 'package:harbour_frontend/models/session.dart';
import 'dart:async';
import 'package:harbour_frontend/models/token.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/routes.dart';
import 'package:harbour_frontend/text_templates.dart';
import 'package:localstorage/localstorage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> validateSession() async {
    late Token jwt;
    try {
      final ls = LocalStorage('harbour.json');

      jwt = Token.fromJSON(ls.getItem('access_token'));
    } catch (e) {
      return Future.error(Exception('Access token not found'));
    }

    try {
      return await Session.refresh()
          .timeout(const Duration(seconds: 10), onTimeout: () => false);
    } on Exception catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<bool>(
            future: Session.refresh(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return HomepageWidget(user: Session.user!);
              } else if (snapshot.hasData && !snapshot.data!) {
                Routes.router.pushReplacement('/login');
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

class HomepageWidget extends StatelessWidget {
  HomepageWidget({super.key, required this.user});

  final User user;
  late final ColorScheme colors;

  void logout() {
    final ls = LocalStorage('harbour.json');
    ls.deleteItem('access_token');
    Routes.router.pushReplacement('/login');
  }

  @override
  Widget build(BuildContext context) {
    colors = Theme.of(context).colorScheme;

    return Center(
        child: FittedBox(
      child: Column(
        children: [
          Text("Your username is:\n${user.username}"),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                onPressed: () => logout(),
                child: TextTemplates.medium('Log out', colors.onSurface)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                onPressed: () => Routes.router.pushReplacement('/vesseltest'),
                child: TextTemplates.medium('Go to vessel', colors.onSurface)),
          ),
        ],
      ),
    ));
  }
}
