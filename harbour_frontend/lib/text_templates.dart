import 'package:flutter/material.dart';

abstract class TextTemplates {

  static RichText headline(String text, Color color) {
    return RichText(
        text: TextSpan(
            text: text,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 48.0, color: color)));
  }

  static RichText heavy(String text, Color color) {
    return RichText(
        text: TextSpan(
            text: text,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 28.0, color: color)));
  }

  static RichText medium(String text) {
    return RichText(
        text: TextSpan(text: text, style: const TextStyle(fontSize: 14.0)));
  }
}
