import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message,
    {Color color = Colors.white}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
      ),
    );
}

void showErrorSnackBar(BuildContext context, String message) {
  showSnackBar(context, message, color: AppPalette.errorColor);
}
