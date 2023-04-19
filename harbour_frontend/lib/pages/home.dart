import 'package:flutter/material.dart';
import 'package:harbour_frontend/common/avatar.dart';
import 'package:harbour_frontend/common/navbar.dart';
import 'package:harbour_frontend/models/session.dart';
import 'dart:async';
import 'package:harbour_frontend/models/token.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/routes.dart';
import 'package:harbour_frontend/text_templates.dart';
import 'package:localstorage/localstorage.dart';
import 'package:harbour_frontend/models/vessel_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user;

  var vessels = <Vessel>[];

  Future<bool> validateSession() async {
    try {
      final ls = LocalStorage('harbour.json');

      Token.fromJSON(ls.getItem('access_token'));
    } catch (e) {
      return Future.error(Exception('Access token not found'));
    }

    try {
      return await Session.refresh()
          .timeout(const Duration(seconds: 10), onTimeout: () => false);
    } on Exception catch (e) {
      return false;
    }
  }

  Future<List<Vessel>> getJoinedVessels() async {
    return [
      Vessel(id: "test", name: "test"),
      Vessel(id: "test", name: "test"),
      Vessel(id: "test", name: "test")
    ];
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
        bottomNavigationBar: HarbourNavBar(index: 0),
        body: FutureBuilder<bool>(
            future: Session.refresh(),
            builder: (context, snapshot) {
              if (snapshot.hasData && !snapshot.data!) {
                Routes.router.pushReplacement('/login');
              } else if (snapshot.hasError) {
                Future.delayed(const Duration(seconds: 5),
                    () => Routes.router.pushReplacement('/login'));
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData && snapshot.data!) {
                user = Session.user!;
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Avatar(user: user.username),
                      ),
                      TextTemplates.headline(
                          user.username, colors.onBackground),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextTemplates.heavy(
                            "Your vessels:", colors.onBackground),
                      ),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: FutureBuilder<List<Vessel>>(
                              future: getJoinedVessels(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) =>
                                          Text(snapshot.data![index].name));
                                }
                                return Container();
                              }),
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.search),
                        label: TextTemplates.heavy(
                            "Browse vessels", colors.onSurface),
                        onPressed: () {
                          Routes.router.push('/browse/vessels');
                        },
                      ),
                    ],
                  ),
                );
              }
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(const Size.square(80)),
                  child: const CircularProgressIndicator(
                    strokeWidth: 6.0,
                  ),
                ),
              );
            }));
  }
}
