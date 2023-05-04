import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harbour_frontend/api/vessel_service.dart';
import 'package:harbour_frontend/models/session.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/text_templates.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Consumer<Session>(builder: (context, session, child) {
      return FutureBuilder(
          future: VesselService().getUsers(session),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scrollbar(
                child: ListView.builder(
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Center(child: TextTemplates.heavy("Users", colors.onBackground));
                    } else {
                      User user = snapshot.data![index - 1];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        tileColor: colors.primary,
                        title: Text(user.username),
                        subtitle: Text(user.email),
                      ),
                    );
                    }
                    
                  },
                ),
              );
            } else {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            }
          });
    });
  }
}
