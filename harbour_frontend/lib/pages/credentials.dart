// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:harbour_frontend/text_templates.dart';

abstract class CredentialsPage extends StatelessWidget {
  const CredentialsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.topCenter,
      child: FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: body(context),
        ),
      ),
    ));
  }

  // The login and register pages will override this with their own widgets
  List<Widget> body(BuildContext context) {
    return [];
  }
}

class LoginPage extends CredentialsPage {
  const LoginPage({Key? key}) : super(key: key);

  @override
  List<Widget> body(BuildContext context) {
    return [
      TextTemplates.headline("Log in", Theme.of(context).colorScheme.onPrimary),
    ];
  }
}

class RegisterPage extends CredentialsPage {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  List<Widget> body(BuildContext context) {
    return [
      TextTemplates.headline("Sign up", Theme.of(context).colorScheme.onPrimary),
    ];
  }
}
