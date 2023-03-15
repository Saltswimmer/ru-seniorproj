// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:harbour_frontend/routes.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  Future<void> landingRedirect() async {
    Routes.router.push('/register');
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 3), landingRedirect);

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
