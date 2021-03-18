import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final ThemeData materialThemeData = ThemeData(
  primarySwatch: Colors.indigo,
  scaffoldBackgroundColor: Colors.white,
  accentColor: Colors.indigo,
  appBarTheme: AppBarTheme(color: Colors.indigo.shade600),
  primaryColor: Colors.indigo,
  secondaryHeaderColor: Colors.indigo,
  canvasColor: Colors.indigo,
  backgroundColor: Colors.red,
);
final CupertinoThemeData cupertinoThemeData = CupertinoThemeData(
  primaryColor: Colors.indigo,
  barBackgroundColor: Colors.indigo,
  scaffoldBackgroundColor: Colors.white,
);
final toolbarTextStyle = TextStyle(color: Colors.white, fontSize: 16);
final cupertinoCardTitleStyle =
    TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600);
final cupertinoCardSubtitleStyle =
    TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400);
final bottomTabsBackground = Colors.indigoAccent;
