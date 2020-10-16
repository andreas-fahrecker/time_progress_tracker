import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_progress_calculator/app.dart';
import 'package:time_progress_calculator/middleware/store_time_progress_middleware.dart';
import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/persistence/time_progress_repository.dart';
import 'package:time_progress_calculator/reducers/app_state_reducer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(TimeProgressCalculatorApp(
    store: Store<AppState>(
      appStateReducer,
      initialState: AppState.initial(),
      middleware: createStoreTimeProgressListMiddleware(
        TimeProgressRepository(await SharedPreferences.getInstance()),
      ),
    ),
  ));
}
