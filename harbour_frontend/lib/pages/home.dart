import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harbour_frontend/api/user_service.dart';
import 'package:harbour_frontend/api/vessel_service.dart';
import 'package:harbour_frontend/models/session.dart';
import 'dart:async';
import 'package:harbour_frontend/text_templates.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../models/vessel_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomepageWidget());
  }
}

class HomepageWidget extends StatefulWidget {
  const HomepageWidget({super.key});

  @override
  State<HomepageWidget> createState() => _HomepageWidgetState();
}

class _HomepageWidgetState extends State<HomepageWidget> {
  bool _onlyMine = true;
  bool _showVessels = true;
  bool _showDMs = true;

  String _searchQuery = '';

  late final TextEditingController _controller;

  List<Vessel> _vessels = [];
  List<Vessel> _myVessels = [];

  late Future<void> Function() search;

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

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    final _formKey = GlobalKey<FormState>();

    bool lock = Provider.of<Session>(context, listen: true).lock;

    if (lock) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(const Size.square(80)),
          child: const CircularProgressIndicator(strokeWidth: 6.0),
        ),
      );
    }
    return Consumer<Session>(builder: (context, session, child) {
      search = () async {
        if (_searchQuery.isEmpty || _searchQuery.length < 3) return;

        try {
          List<Vessel> results =
              await VesselService().search(session, _searchQuery);
          setState(() {
            _vessels = results;
          });
        } on Error catch (e) {
          print(e);
          return;
        }
      };

      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: colors.primary,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: CircleAvatar(
                        maxRadius: 50,
                        backgroundColor: colors.surface,
                        child: TextTemplates.headline(
                            session.user!.username[0], colors.onSurface),
                      ),
                    ),
                    FittedBox(
                      child: TextTemplates.headline(
                          session.user!.username, colors.onPrimary),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton.icon(
                          icon: Icon(Icons.logout),
                          label:
                              TextTemplates.large("Log out", colors.onSurface),
                          onPressed: () {
                            session.wipe();
                            Future.microtask(() => context.go('/login'));
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextTemplates.heavy("Your conversations",
                                      colors.onBackground),
                                  TextFormField(
                                    autofocus: true,
                                    key: _formKey,
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                        hintText: "Search for conversations"),
                                  ),
                                ],
                              ),
                            ),
                          )),
                          Flexible(
                            child: ListView(
                              children: <CheckboxListTile>[
                                CheckboxListTile(
                                    value: _onlyMine,
                                    activeColor: colors.surface,
                                    title: TextTemplates.medium(
                                        "Only show your conversations",
                                        colors.onBackground),
                                    tileColor: colors.background,
                                    onChanged: (v) => setState(() {
                                          if (v != null) _onlyMine = v;
                                        })),
                                CheckboxListTile(
                                    value: _showVessels,
                                    activeColor: colors.surface,
                                    title: TextTemplates.medium(
                                        "Show vessels", colors.onBackground),
                                    tileColor: colors.background,
                                    onChanged: (v) => setState(() {
                                          if (v != null) _showVessels = v;
                                        })),
                                CheckboxListTile(
                                    value: _showDMs,
                                    activeColor: colors.surface,
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
                      flex: 10,
                      child: DataTable(
                          showBottomBorder: true,
                          columns: [
                            DataColumn(
                                label: TextTemplates.large(
                                    "Name", colors.onBackground)),
                            DataColumn(
                                label: TextTemplates.large(
                                    "       ", colors.onBackground)),
                          ],
                          rows: _vessels
                              .map<DataRow>((e) => DataRow(cells: [
                                    DataCell(Text(e.name)),
                                    session.vessels!.containsKey(e.vessel_id)
                                        ? DataCell(ElevatedButton(
                                            child: Text("View"),
                                            onPressed: () {
                                              session.currentVessel = e;
                                              Future.microtask(() =>
                                                  context.push('/vessel'));
                                            },
                                          ))
                                        : DataCell(ElevatedButton(
                                            child: Text("Join"),
                                            onPressed: () {
                                              Future.microtask(() =>
                                                  VesselService()
                                                      .joinVessel(session, e)
                                                      .then((value) {
                                                    session.addVessel(e);
                                                    session.currentVessel = e;
                                                    context.push('/vessel');
                                                  }));
                                            },
                                          ))
                                  ]))
                              .toList()),
                    ),
                    Flexible(
                        flex: 1,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add_box),
                          label: TextTemplates.large(
                              "Create a new vessel", colors.onSurface),
                          onPressed: () => context.push("/vessel/new"),
                        ))
                  ],
                ),
              )),
        ],
      );
    });
  }
}
