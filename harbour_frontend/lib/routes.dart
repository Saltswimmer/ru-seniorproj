import 'package:flutter/material.dart';
import 'package:harbour_frontend/pages/landing.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (c) => LandingPage(),
    '/login': (c) => LandingPage(),
    '/register': (c) => LandingPage(),
  };
}
