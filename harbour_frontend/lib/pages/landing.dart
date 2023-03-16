// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:harbour_frontend/routes.dart';
import 'package:localstorage/localstorage.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  Future<void> landingRedirect() async {
    try {
      final ls = LocalStorage('harbour.json');

      String? jwt = ls.getItem('auth_token');
      if (jwt == null) {
        throw Error();
      }

      // Check with server to see if token is expired

      print('Token found!');
    } catch (e) {
      Routes.router.pushReplacement('/login');
    }

    // Change this to last viewed server?
    Routes.router.pushReplacement('/login');
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), landingRedirect);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size.square(80)),
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
            strokeWidth: 6.0,
          ),
        ),
      ),
    );
  }
}
