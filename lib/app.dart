import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/screens/progress_screen.dart';

class TimeProgressCalculatorApp extends StatelessWidget {
  final Store<AppState> store;

  TimeProgressCalculatorApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: "Time Progress Calculator",
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        initialRoute: "/",
        routes: {
          "/": (BuildContext context) => ProgressScreen(
                name: "Zivildienst",
                context: context,
              )
        },
      ),
    );
  }
}
