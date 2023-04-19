import 'package:flutter/material.dart';
import 'routes.dart';

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
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: scheme.secondary,

      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.white,
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.white,

      )),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.shadow,
        hoverColor: Colors.white10,
        hintStyle: const TextStyle(
          color: Colors.white38,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 4.0,
            color: Colors.white38
          )
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 4.0,
            color: scheme.surface
          )
        )
      ),
    ),
    routerConfig: Routes.router,
  ));
}

const ColorScheme scheme = ColorScheme.highContrastDark(
    background: Color(0xff1f2f3f),
    onBackground: Color(0xfff0f0f0),
    primary: Color(0xff334455),
    onPrimary: Colors.white,
    secondary: Color(0xffff7f5f),
    onSecondary: Colors.black,
    shadow: Colors.black45,
    surface: Color(0xff77ccff),
    onSurface: Color(0xff1f2f3f),
    );
