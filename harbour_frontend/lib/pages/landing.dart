// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size.square(80)),
          child: CircularProgressIndicator(
            color: Color(0xFFFF7F5F),
            strokeWidth: 6.0,
          ),
        ),
      ),
    );
  }
}
