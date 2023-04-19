import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:harbour_frontend/pages/landing.dart';
import 'package:harbour_frontend/pages/credentials.dart';
import 'package:harbour_frontend/pages/home.dart';
import 'package:harbour_frontend/pages/vessel/vessel.dart';
import 'package:harbour_frontend/pages/logout.dart';

class Routes {
  static void reset() {
    router.dispose();
    router = makeRouter();
  }

  static GoRouter makeRouter() {
    return GoRouter(routes: <RouteBase>[
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
              path: 'logout',
              builder: (BuildContext context, GoRouterState state) =>
                const Logout(),
            ),
            GoRoute(
              path: 'register',
              builder: (BuildContext context, GoRouterState state) =>
                  const RegisterPage(),
            ),
            GoRoute(
              path: 'home',
              builder: (BuildContext context, GoRouterState state) =>
                  const HomePage(),
            ),
            GoRoute(
              path: 'vesseltest',
              builder: (BuildContext context, GoRouterState state) =>
                  const VesselPage(),
            )
          ])
    ]);
  }

  static GoRouter router = makeRouter();
}
