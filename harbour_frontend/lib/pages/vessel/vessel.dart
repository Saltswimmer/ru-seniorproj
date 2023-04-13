import 'package:flutter/material.dart';
import 'chatpanel.dart';

class VesselPage extends StatelessWidget {
  const VesselPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Row(
        // columns go here
        children: <Widget>[
          Column(),
          Expanded(child: ChatPanel()),
          Column()])));
  }
}
