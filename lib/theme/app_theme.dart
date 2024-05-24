import 'package:flutter/material.dart';

ThemeData lightTheme() {
  final theme = ThemeData.from(
    useMaterial3: false,
    colorScheme: const ColorScheme.light(
      primary: Colors.lightBlueAccent,
      background: Colors.white,
    ),
  );
  return theme.copyWith(
    scaffoldBackgroundColor: theme.colorScheme.background,
    textTheme: theme.textTheme.apply(
      displayColor: theme.colorScheme.onBackground,
      bodyColor: theme.colorScheme.onBackground,
    ),
    canvasColor: theme.colorScheme.surface,
    appBarTheme: theme.appBarTheme.copyWith(
      elevation: 0,
    ),
  );
}
