// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:harbour_frontend/text_templates.dart';

class CredentialsPageMixin {

  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.topCenter,
      child: FittedBox(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: body(context),
          ),
        ),
      ),
    ));
  }

  List<Widget> body(BuildContext context) {
    return [];
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> with CredentialsPageMixin {

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  List<Widget> body(BuildContext context) {
    return [
      TextTemplates.headline('Log in', Theme.of(context).colorScheme.onPrimary),

      // EMAIL
      TextField(
        autocorrect: false,
        enableSuggestions: false,
        controller: _email,
        decoration: InputDecoration(
          hintText: 'Enter your email address',
        ),
      ),

      // PASSWORD
      TextField(
        autocorrect: false,
        enableSuggestions: false,
        obscureText: true,
        controller: _password,
        decoration: InputDecoration(
          hintText: 'Enter your password',
        ),
      ),

      // LOGIN BUTTON
      TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;

            // Do some auth stuff here
          },
          child: const Text('Log in')),
    ];
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> with CredentialsPageMixin {

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  List<Widget> body(BuildContext context) {
    return [
      TextTemplates.headline(
          'Sign up', Theme.of(context).colorScheme.onPrimary),

      // EMAIL
      TextField(
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: TextInputType.emailAddress,
        controller: _email,
        decoration: InputDecoration(
          hintText: 'Enter your email address',
        ),
      ),

      // PASSWORD
      TextField(
        autocorrect: false,
        enableSuggestions: false,
        obscureText: true,
        controller: _password,
        decoration: InputDecoration(
          hintText: 'Enter a strong password',
        ),
      ),

      // CONFIRM PASSWORD
      TextField(
        autocorrect: false,
        enableSuggestions: false,
        obscureText: true,
        controller: _confirmPassword,
        decoration: InputDecoration(
          hintText: 'Confirm your password',
        ),
      ),

      // REGISTER BUTTON
      TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            final confirmPassword = _confirmPassword.text;
          },
          child: const Text('Register')),
    ];
  }
}
