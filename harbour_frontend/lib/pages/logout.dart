import 'package:flutter/material.dart';
import 'package:harbour_frontend/routes.dart';
import 'package:localstorage/localstorage.dart';

import '../models/session.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ls = LocalStorage('harbour.json');
    ls.deleteItem('access_token');
    Session.upToDate = false;
    Routes.router.push('/login');
    return const Text("you shouldn't see this");
  }
}
