import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harbour_frontend/models/session.dart';
import 'package:harbour_frontend/pages/create_vessel.dart';

import 'package:harbour_frontend/pages/landing.dart';
import 'package:harbour_frontend/pages/credentials.dart';
import 'package:harbour_frontend/pages/home.dart';
import 'package:harbour_frontend/pages/vessel/vessel.dart';
import 'package:provider/provider.dart';

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
              path: 'register',
              builder: (BuildContext context, GoRouterState state) =>
                  const RegisterPage(),
            ),
            GoRoute(
              path: 'logout',
              builder: (BuildContext context, GoRouterState state) =>
                  Consumer<Session>(builder: (context, session, child) {
                Future.microtask(() {
                  session.wipe();
                  context.go('/login');
                });
                return Scaffold();
              }),
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
            ),
            GoRoute(
                path: 'vessel',
                builder: (BuildContext context, GoRouterState state) =>
                    const VesselPage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'new',
                    builder: (BuildContext context, GoRouterState state) =>
                        CreateVesselPage(),
                  ),
                ])
          ])
    ]);
  }

  static GoRouter router = makeRouter();
}
