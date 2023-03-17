import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:harbour_frontend/api/user_service.dart';
import 'package:harbour_frontend/models/user_model.dart';

void main() {
  runApp(MaterialApp.router(
    title: 'Flutter Demo',
    theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        colorScheme: scheme),
    routerConfig: Routes.router,
  ));
}

const ColorScheme scheme = ColorScheme.highContrastDark(
    background: Color(0xff1f2f3f),
      onBackground: Color(0xfff0f0f0),
    primary: Color(0xff445566),
      onPrimary: Colors.white,
    secondary: Color(0xffff7f5f),
      onSecondary: Colors.black);
