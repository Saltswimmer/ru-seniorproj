import 'dart:async';

import 'package:flutter/material.dart';

import '../models/user_model.dart';

//THIS FILE IS CURRENTLY STANDALONE AND WILL HAVE TO BE INTEGRATED
//TO INCLUDE THE CORRECT DATA STRUCTURES AND JSON REQUESTS FROM
//VESSELS.dart FILE

class VesselList extends StatefulWidget {
  final List<Vessel> users;

  VesselList({required this.users});

  @override
  _VesselListState createState() => _VesselListState();
}

class _VesselListState extends State<VesselList> {

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