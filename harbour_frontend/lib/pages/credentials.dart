// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harbour_frontend/models/session.dart';
import 'package:harbour_frontend/models/token.dart';
import 'package:harbour_frontend/text_templates.dart';
import 'package:harbour_frontend/api/user_service.dart';
import 'package:localstorage/localstorage.dart';

class CredentialsPageMixin {
  late ColorScheme colors;

  late TextField base;

  InputDecoration makeInputDecoration(String hint) {
    return InputDecoration(
        hintText: hint,
        labelStyle: TextStyle(color: colors.surface),
        errorStyle: TextStyle(color: colors.secondary),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.secondary)),
        border: UnderlineInputBorder(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6.0),
                topRight: Radius.circular(4.0))));
  }

  Widget build(BuildContext context) {
    colors = Theme.of(context).colorScheme;

    base = TextField(
      autocorrect: false,
      cursorColor: colors.secondary,
      enableSuggestions: false,
    );

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.topCenter,
        child: FittedBox(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Container(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.flag_sharp,
                        size: 42, color: colors.onBackground),
                    TextTemplates.headline("Harbour", colors.onBackground),
                  ])
                ].followedBy(body(context)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
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
  final _formKey = GlobalKey<FormState>();

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

  Future<void> landingRedirect() async {
    try {
      final ls = LocalStorage('harbour.json');

      String jwt = ls.getItem('access_token');

      // Check with server to see if token is expired

      // If user already has an active session skip the login screen

      // Routes.router.pushReplacement(...)
    } catch (e) {}
  }

  @override
  List<Widget> body(BuildContext context) {
    landingRedirect();
    return [
      Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // EMAIL
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autocorrect: false,
                    cursorColor: colors.surface,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: makeInputDecoration('Enter your email'),
                    controller: _email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email address';
                      }
                      return null;
                    },
                  ),
                ),

                // PASSWORD
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autocorrect: false,
                    cursorColor: colors.surface,
                    enableSuggestions: false,
                    obscureText: true,
                    decoration: makeInputDecoration('Enter your password'),
                    controller: _password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                ),

                // LOGIN BUTTON
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;

                        if (_formKey.currentState!.validate()) {
                          try {
                            UserService().signin({
                              'email': email,
                              'password': password,
                            });
                            context.go('/');
                          } on Exception catch (e) {
                            print(e.toString());
                            Session.upToDate = false;
                          }
                        }
                      },
                      child: TextTemplates.large('Log in', colors.onSurface)),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: colors.onBackground),
                  onPressed: () => context.push('/register'),
                  child: TextTemplates.medium(
                      "Don't have an account? Sign up!", colors.onBackground),
                ),
              ],
            ),
          )),
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
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            // EMAIL
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autocorrect: false,
                cursorColor: colors.surface,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                decoration: makeInputDecoration('Enter your email'),
                controller: _email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email address';
                  }
                  return null;
                },
              ),
            ),

            // USERNAME
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autocorrect: false,
                cursorColor: colors.surface,
                enableSuggestions: false,
                decoration: makeInputDecoration('What should people call you?'),
                controller: _username,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a username';
                  } else if (RegExp(r'[^a-zA-Z_]').hasMatch(value)) {
                    return 'Only Latin alphabet letters and underscores are allowed in usernames';
                  }
                  return null;
                },
              ),
            ),

            // PASSWORD
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autocorrect: false,
                cursorColor: colors.surface,
                enableSuggestions: false,
                obscureText: true,
                decoration: makeInputDecoration('Enter your password'),
                controller: _password,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
            ),

            // CONFIRM PASSWORD
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autocorrect: false,
                cursorColor: colors.surface,
                enableSuggestions: false,
                obscureText: true,
                decoration: makeInputDecoration('Enter your password'),
                controller: _confirmPassword,
                validator: (value) {
                  if (value != _password.text) {
                    return 'Both passwords must match';
                  }
                  return null;
                },
              ),
            ),

            // REGISTER BUTTON
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final username = _username.text;
                    final password = _password.text;

                    if (_formKey.currentState!.validate()) {
                      try {
                        UserService().signup({
                          'first_name': '',
                          'middle_name': '',
                          'last_name': '',
                          'email': email,
                          'username': username,
                          'password': password,
                        });
                        context.go('/');
                      } on Exception catch (e) {
                        print(e.toString());
                      }
                    }
                  },
                  child: TextTemplates.large('Register', colors.onSurface)),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: colors.onBackground),
              onPressed: () => context.push('/login'),
              child: TextTemplates.medium(
                  "Already have an account? Sign in.", colors.onBackground),
            ),
          ]),
        ),
      ),
    ];
  }
}
