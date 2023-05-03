import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harbour_frontend/api/vessel_service.dart';
import 'package:harbour_frontend/models/session.dart';
import 'package:harbour_frontend/models/token.dart';
import 'package:harbour_frontend/models/vessel_model.dart';
import 'package:harbour_frontend/text_templates.dart';
import 'package:provider/provider.dart';

class CreateVesselPage extends StatefulWidget {
  @override
  State<CreateVesselPage> createState() => _CreateVesselPageState();
}

class _CreateVesselPageState extends State<CreateVesselPage> {
  InputDecoration makeInputDecoration(String hint) {
    return InputDecoration(
        hintText: hint,
        labelStyle: TextStyle(color: colors.surface),
        errorStyle: TextStyle(color: colors.secondary),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.secondary)),
        border: const UnderlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.0),
                topRight: Radius.circular(4.0))));
  }

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  late ColorScheme colors;

  bool makePublic = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    colors = Theme.of(context).colorScheme;

    return Consumer<Session>(builder: (context, session, child) {
      return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: colors.primary,
                title: TextTemplates.heavy(
                    "Create a new vessel", colors.onPrimary),
              ),
              body: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 375, maxHeight: 500),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _controller,
                            decoration: makeInputDecoration(
                                "Enter a name for the vessel"),
                            autocorrect: false,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a name for the vessel";
                              }
                            },
                          ),
                          CheckboxListTile(
                              value: makePublic,
                              activeColor: colors.surface,
                              title: TextTemplates.large(
                                  "Make this vessel public",
                                  colors.onBackground),
                              subtitle: TextTemplates.medium(
                                  "Anyone can join public vessels",
                                  Colors.white38),
                              onChanged: (val) {
                                setState(() {
                                  makePublic = val!;
                                });
                              }),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              child: TextTemplates.large(
                                  "Create new vessel", colors.onSurface),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Create the new vessel
                                  try {
                                    Vessel? v = await VesselService()
                                        .createVessel(
                                            session, _controller.text);

                                    if (v != null) {
                                      session.addVessel(v);
                                      session.currentVessel = v;
                                    }
                                  } on Error catch (e) {
                                    print(e);
                                  }
                                  Future.microtask(
                                      () => context.pushReplacement('/vessel'));
                                }
                              },
                            ),
                          )
                        ],
                      )),
                ),
              )));
    });
  }
}
