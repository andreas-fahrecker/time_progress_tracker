import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_calculator/app.dart';
import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/reducers/app_state_reducer.dart';
import 'package:time_progress_calculator/screens/progress_screen.dart';

void main() {
  runApp(TimeProgressCalculatorApp(
    store: Store<AppState>(appStateReducer, initialState: AppState.initial()),
  ));
}
