import 'package:flutter/material.dart';
import 'package:harbour_frontend/routes.dart';
import 'package:harbour_frontend/models/session.dart';

class HarbourNavBar extends BottomNavigationBar {
  static void route(int index) {
    late String route;
    switch (index) {
      case 0:
        route = "/home";
        break;
      case 1:
        route = "/settings";
        break;
      case 2:
        Session.logout();
        return;
      default:
        route = "/";
        break;
    }
    Routes.router.pushReplacement(route);
  }

  HarbourNavBar({Key? key, required int index})
      : super(
        key: key,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Log out"),
        ],
        selectedItemColor: Colors.blue[600],
        currentIndex: index,
        onTap: route);
}
