import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/screens/progress_creation_screen.dart';
import 'package:time_progress_tracker/screens/progress_dashboard_screen.dart';
import 'package:time_progress_tracker/screens/progress_detail_screen.dart';

class TimeProgressTrackerApp extends StatelessWidget {
  static const String name = "Time Progress Tracker";

  final Store<AppState> store;
  final String appVersion;

  TimeProgressTrackerApp({
    Key key,
    this.store,
    this.appVersion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: name,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: ProgressDashboardScreen.routeName,
        routes: {
          ProgressDashboardScreen.routeName: (BuildContext context) =>
              ProgressDashboardScreen(
                appVersion: appVersion,
              ),
          ProgressDetailScreen.routeName: (BuildContext context) =>
              ProgressDetailScreen(
                appVersion: appVersion,
              ),
          ProgressCreationScreen.routeName: (BuildContext context) =>
              ProgressCreationScreen(
                appVersion: appVersion,
              ),
        },
      ),
    );
  }
}
