import 'package:flutter/material.dart';
import 'package:harbour_frontend/routes.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Routes.router.pushReplacement("/login");
    return Container();
  }
}
