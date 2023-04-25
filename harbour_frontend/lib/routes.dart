import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harbour_frontend/models/session.dart';
import 'package:harbour_frontend/pages/create_vessel.dart';

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
          redirect: (context, state) async {
            try {
              Session session = Provider.of<Session>(context, listen: false);
              if (!session.attemptedRestore) {
                if (await session.restore()) {
                  return '/home';
                } else {
                  return '/login';
                }
              }
            } on Error catch (e) {}
            return null;
          },
          builder: (BuildContext context, GoRouterState state) {
            return Scaffold(
              body: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(80)),
                  child: const CircularProgressIndicator(
                    strokeWidth: 6.0,
                  ),
                ),
              ),
            );
          },
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
