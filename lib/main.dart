import 'package:flutter/material.dart';
import 'package:time_progress_calculator/screens/progress_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Progress Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => ProgressScreen(
              name: "Zivildienst",
            )
      },
    );
  }
}
