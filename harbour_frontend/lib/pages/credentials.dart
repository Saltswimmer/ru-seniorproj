// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:harbour_frontend/models/token.dart';
import 'package:harbour_frontend/text_templates.dart';
import 'package:harbour_frontend/api/user_service.dart';
import 'package:localstorage/localstorage.dart';
import 'package:harbour_frontend/routes.dart';

class CredentialsPageMixin {
  late ColorScheme colors;

  late TextField base;

  Widget makeTextField(
          {required TextEditingController controller,
          String? Function(String?)? validator, // this type is amazing
          String? hint,
          bool obscureText = false,
          bool isEmail = false}) =>
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          autocorrect: false,
          cursorColor: colors.surface,
          enableSuggestions: false,
          obscureText: obscureText,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
              hintText: hint,
              labelStyle: TextStyle(
                color: colors.surface,
              ),
              border: UnderlineInputBorder(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6.0),
                      topRight: Radius.circular(4.0)))),
          controller: controller,
        ),
      );

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
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // EMAIL
                makeTextField(
                    controller: _email,
                    hint: 'Enter your email address',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email address';
                      }
                    },
                    isEmail: true),

                // PASSWORD
                makeTextField(
                  controller: _password,
                  hint: 'Enter your password',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                  },
                  obscureText: true,
                ),

                // LOGIN BUTTON
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;

                        // Do some auth stuff here
                      },
                      child: TextTemplates.large('Log in', colors.onSurface)),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: colors.onBackground),
                  onPressed: () => Routes.router.push('/register'),
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
      Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            // EMAIL
            makeTextField(
              controller: _email,
              hint: 'Enter your email address',
              isEmail: true,
            ),

            // USERNAME
            makeTextField(
              controller: _username,
              hint: 'What should other people call you?',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a username';
                } else if (RegExp(r'[^a-zA-Z_]').hasMatch(value)) {
                  return 'Only Latin alphabet letters and underscores are allowed in usernames';
                }
              },
            ),

            // PASSWORD
            makeTextField(
              controller: _password,
              hint: 'Enter a strong password',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
              },
              obscureText: true,
            ),

            // CONFIRM PASSWORD
            makeTextField(
              controller: _confirmPassword,
              hint: 'Confirm your password',
              validator: (value) {
                if (value != _password.text) {
                  return 'Both passwords must match';
                }
              },
              obscureText: true,
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
                      late Token jwt;
                      try {
                        jwt = await UserService().signup({
                          'first_name': '',
                          'middle_name': '',
                          'last_name': '',
                          'email': email,
                          'username': username,
                          'password': password,
                        });
                      } on Exception catch (e) {
                        print(e.toString());
                      }

                      try {
                        final ls = LocalStorage('harbour.json');
                        //print(jwt.accessToken);
                        ls.setItem('access_token', jwt);
                      } catch (e) {
                        print(e.toString());
                      }

                      Routes.router.pushReplacement('/');
                    }
                  },
                  child: TextTemplates.large('Register', colors.onSurface)),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: colors.onBackground),
              onPressed: () => Routes.router.push('/login'),
              child: TextTemplates.medium(
                  "Already have an account? Sign in.", colors.onBackground),
            ),
          ]),
        ),
      ),
    ];
  }
}
