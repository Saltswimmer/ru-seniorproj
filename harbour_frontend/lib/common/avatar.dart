import 'package:flutter/material.dart';
import 'package:harbour_frontend/text_templates.dart';

class Avatar extends StatelessWidget {
  Avatar({Key? key, required this.user}) : super(key: key);

  late final ColorScheme colors;
  late final String user;

  @override
  Widget build(BuildContext context) {
    colors = Theme.of(context).colorScheme;
    return CircleAvatar(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      child: TextTemplates.heavy(user[0], colors.onSurface),
    );
  }
}
