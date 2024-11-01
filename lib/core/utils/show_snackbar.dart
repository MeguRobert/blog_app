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
