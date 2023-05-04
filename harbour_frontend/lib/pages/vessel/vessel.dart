import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harbour_frontend/models/session.dart';
import 'package:harbour_frontend/pages/vessel/users-vessels.dart';
import 'package:harbour_frontend/text_templates.dart';
import 'package:provider/provider.dart';
import 'chatpanel.dart';

class VesselPage extends StatefulWidget {
  const VesselPage({Key? key}) : super(key: key);

  @override
  State<VesselPage> createState() => _VesselPageState();
}

class _VesselPageState extends State<VesselPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

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
      return Scaffold(
          appBar: AppBar(
              backgroundColor: colors.primary,
              title: TextTemplates.heavy(
                  session.currentVessel!.name, colors.onPrimary)),
          body: SafeArea(
              child: Row(
                  // columns go here
                  children: <Widget>[
                
                Expanded(child: ChatPanel(), flex: 4,),
                
                Expanded(
                    child:
                        UserList()) // <-- This needs the argument of having the user list of the current vessel passed in
              ])));
    });
  }
}
