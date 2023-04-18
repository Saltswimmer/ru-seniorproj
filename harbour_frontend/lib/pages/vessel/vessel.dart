import 'package:flutter/material.dart';
import 'chatpanel.dart';
import 'users-vessels.dart';
import 'package:harbour_frontend/models/user_model.dart';

class VesselPage extends StatelessWidget {
  final List<User> users;
  const VesselPage({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Row(
                // columns go here
                children: <Widget>[
          Column(),
          Expanded(child: ChatPanel()),
          Column(),
          Expanded(
              child: UserList(
                  users:
                      users)) // <-- This needs the argument of having the user list of the current vessel passed in
        ])));
  }
}
