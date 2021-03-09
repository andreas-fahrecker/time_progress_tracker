import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/screens/dashboard_screen.dart';
import 'package:time_progress_tracker/utils/color_utils.dart';

class TimeProgressTrackerApp extends StatelessWidget {
  static const String name = "Time Progress Tracker";

  final Store<AppState> store;

  TimeProgressTrackerApp({
    Key key,
    this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: PlatformApp(
        title: name,
        home: DashboardScreen(),
        material: (_, __) => MaterialAppData(theme: materialThemeData),
        cupertino: (_, __) => CupertinoAppData(theme: cupertinoThemeData),
      ),
    );
  }
}
