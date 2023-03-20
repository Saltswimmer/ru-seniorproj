// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:harbour_frontend/routes.dart';
import 'package:localstorage/localstorage.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  Future<void> landingRedirect() async {
    if (LocalStorage('harbour.json').getItem('access_token') == null) {
        Routes.router.push('/login');
    } else {
      Routes.router.push('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), landingRedirect);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size.square(80)),
          child: CircularProgressIndicator(
            strokeWidth: 6.0,
          ),
        ),
      ),
    );
  }
}
