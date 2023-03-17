// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/text_templates.dart';
import 'package:harbour_frontend/api/user_service.dart';
import 'package:harbour_frontend/models/token.dart';
import 'package:dio/dio.dart';

class CredentialsPageMixin {
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
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _email;
  late final TextEditingController _username;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  @override
  void initState() {
    _email = TextEditingController();
    _username = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  List<Widget> body(BuildContext context) {
    return [
      TextTemplates.headline(
          'Sign up', Theme.of(context).colorScheme.onPrimary),
      Form(
          key: _formKey,
          child: Column(children: [
            // EMAIL
            TextFormField(
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              controller: _email,
              decoration: InputDecoration(
                hintText: 'Enter your email address',
              ),
            ),

            // USERNAME
            TextFormField(
              autocorrect: false,
              enableSuggestions: false,
              controller: _username,
              decoration: InputDecoration(
                hintText: 'What should other people call you?',
              ),
            ),

            // PASSWORD
            TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                obscureText: true,
                controller: _password,
                decoration: InputDecoration(
                  hintText: 'Enter a strong password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                }),

            // CONFIRM PASSWORD
            TextFormField(
              autocorrect: false,
              enableSuggestions: false,
              obscureText: true,
              controller: _confirmPassword,
              decoration: InputDecoration(
                hintText: 'Confirm your password',
              ),
              validator: (value) {
                if (value != _password.text) {
                  return 'Both passwords must match';
                }
              },
            ),

            // REGISTER BUTTON
            TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary),
                onPressed: () async {
                  final email = _email.text;
                  final username = _username.text;
                  final password = _password.text;
                  final confirmPassword = _confirmPassword.text;

                  if (_formKey.currentState!.validate()) {
                    Token jwt = await UserService().signup({
                      'first_name': '',
                      'middle_name': '',
                      'last_name': '',
                      'email': email,
                      'username': username,
                    });
                    print(jwt.accessToken);
                  }
                },
                child: TextTemplates.medium(
                    'Register', Theme.of(context).colorScheme.onPrimary)),
          ] // Children
              ))
    ];
  }
}
