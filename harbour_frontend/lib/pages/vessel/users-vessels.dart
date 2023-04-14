import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harbour_frontend/models/user_model.dart';

//THIS FILE IS CURRENTLY STANDALONE AND WILL HAVE TO BE INTEGRATED
//TO INCLUDE THE CORRECT DATA STRUCTURES AND JSON REQUESTS FROM
//VESSELS.dart FILE

class UserList extends StatefulWidget {
  final List<User> users;

  UserList({required this.users});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (BuildContext context, int index) {
        User user = widget.users[index];
        return ListTile(
          title: Text(user.username),
          subtitle: Text(user.email),
        );
      },
    );
  }
}