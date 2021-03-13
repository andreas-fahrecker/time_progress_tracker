import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_progress_tracker/app.dart';
import 'package:time_progress_tracker/redux/app_state.dart';
import 'package:time_progress_tracker/persistence/app_settings.dart';
import 'package:time_progress_tracker/persistence/time_progress.dart';
import 'package:time_progress_tracker/redux/reducers/app_state_reducer.dart';
import 'package:time_progress_tracker/redux/store_middleware.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(TimeProgressTrackerApp(
    store: Store<AppState>(
      appStateReducer,
      initialState: AppState.initial(),
      middleware: createStoreMiddleware(
          TimeProgressRepository(prefs), AppSettingsRepository(prefs)),
    ),
  ));
}
