import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:harbour_frontend/pages/landing.dart';
import 'package:harbour_frontend/pages/credentials.dart';
import 'package:harbour_frontend/pages/home.dart';

class Routes {
  static final GoRouter router = GoRouter(routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const LandingPage(),
        routes: <RouteBase>[
          GoRoute(
            path: 'login',
            builder: (BuildContext context, GoRouterState state) =>
                const LoginPage(),
          ),
          GoRoute(
            path: 'register',
            builder: (BuildContext context, GoRouterState state) =>
                const RegisterPage(),
          ),
          GoRoute(
            path: 'home',
            builder: (BuildContext context, GoRouterState state) =>
              const HomePage(),)
        ])
  ]);
}
