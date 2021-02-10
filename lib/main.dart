import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_progress_tracker/app.dart';
import 'package:time_progress_tracker/middleware/store_time_progress_middleware.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/persistence/time_progress_repository.dart';
import 'package:time_progress_tracker/reducers/app_state_reducer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(TimeProgressTrackerApp(
    store: Store<AppState>(
      appStateReducer,
      initialState: AppState.initial(),
      middleware: createStoreTimeProgressListMiddleware(
        TimeProgressRepository(await SharedPreferences.getInstance()),
      ),
    ),
  ));
}
