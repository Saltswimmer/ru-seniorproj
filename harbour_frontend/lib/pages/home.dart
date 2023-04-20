import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harbour_frontend/api/vessel_service.dart';
import 'package:harbour_frontend/models/session.dart';
import 'dart:async';
import 'package:harbour_frontend/models/token.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/routes.dart';
import 'package:harbour_frontend/text_templates.dart';
import 'package:localstorage/localstorage.dart';

import '../models/vessel_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> validateSession() async {
    late Token jwt;
    try {
      final ls = LocalStorage('harbour.json');

      jwt = Token.fromJSON(ls.getItem('access_token'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<bool>(
            future: Session.refresh(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return HomepageWidget(user: Session.user!);
              } else if (snapshot.hasData && !snapshot.data!) {
                Routes.router.pushReplacement('/login');
              } else if (snapshot.hasError) {
                Future.delayed(const Duration(seconds: 5),
                    () => Routes.router.pushReplacement('/login'));
                return Text(snapshot.error.toString());
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

class HomepageWidget extends StatefulWidget {
  HomepageWidget({super.key, required this.user});

  final User user;

  @override
  State<HomepageWidget> createState() => _HomepageWidgetState();
}

class _HomepageWidgetState extends State<HomepageWidget> {
  bool _onlyMine = true;
  bool _showVessels = true;
  bool _showDMs = true;

  String _searchQuery = '';

  late final TextEditingController _controller;

  List<Vessel> _searchResults = [];

  Future<void> search() async {
    if (_searchQuery.isEmpty || _searchQuery.length < 3) return;

    try {
      _searchResults =
          await VesselService().search(_searchQuery, Session.token!);
    } on Error catch (e) {
      print(e);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      _searchQuery = _controller.text;
      search();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void logout() {
    final ls = LocalStorage('harbour.json');
    ls.deleteItem('access_token');
    Routes.router.pushReplacement('/login');
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    final _formKey = GlobalKey<FormState>();

    return Row(
      children: [
        LimitedBox(
          maxWidth: 150,
          child: Container(
            color: colors.primary,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: CircleAvatar(
                      backgroundColor: colors.onPrimary,
                    ),
                  ),
                  TextTemplates.headline(
                      Session.user!.username, colors.onPrimary)
                ],
              ),
            ),
          ),
        ),
        Expanded(
            child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextTemplates.heavy(
                          "Browse conversations", colors.onBackground),
                      TextFormField(
                        key: _formKey,
                        controller: _controller,
                        decoration: const InputDecoration(
                            hintText: "Search for conversations"),
                      ),
                    ],
                  )),
                  Flexible(
                    child: ListView(
                      children: <CheckboxListTile>[
                        CheckboxListTile(
                            value: _onlyMine,
                            title: TextTemplates.medium(
                                "Only show your conversations",
                                colors.onBackground),
                            tileColor: colors.background,
                            onChanged: (v) => setState(() {
                                  if (v != null) _onlyMine = v;
                                })),
                        CheckboxListTile(
                            value: _showVessels,
                            title: TextTemplates.medium(
                                "Show vessels", colors.onBackground),
                            tileColor: colors.background,
                            onChanged: (v) => setState(() {
                                  if (v != null) _showVessels = v;
                                })),
                        CheckboxListTile(
                            value: _showDMs,
                            title: TextTemplates.medium(
                                "Show direct message conversations",
                                colors.onBackground),
                            tileColor: colors.background,
                            onChanged: (v) => setState(() {
                                  if (v != null) _showDMs = v;
                                })),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: DataTable(
                  columns: [
                    DataColumn(
                        label:
                            TextTemplates.large("Name", colors.onBackground)),
                    DataColumn(
                        label: TextTemplates.large(
                            "Members", colors.onBackground)),
                  ],
                  rows: _searchResults
                      .map<DataRow>((e) => DataRow(
                          cells: [DataCell(Text(e.name)), DataCell(Text('0'))]))
                      .toList()),
            ),
            Flexible(
                flex: 1,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_box),
                  label: TextTemplates.large(
                      "Create a new vessel", colors.onSurface),
                  onPressed: () => Routes.router.push("/vessel/new"),
                ))
          ],
        )),
      ],
    );
  }
}
