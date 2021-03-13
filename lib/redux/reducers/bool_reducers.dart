import 'package:redux/redux.dart';
import 'package:time_progress_tracker/redux/actions/app_settings_actions.dart';
import 'package:time_progress_tracker/redux/actions/redux_actions.dart';
import 'package:time_progress_tracker/redux/actions/time_progress_actions.dart';

final hasProgressesLoadedReducer = combineReducers<bool>([
  TypedReducer<bool, TimeProgressListLoadedAction>(_setTrue),
  TypedReducer<bool, TimeProgressListNotLoadedAction>(_setFalse)
]);

final hasSettingsLoadedReducer = combineReducers<bool>([
  TypedReducer<bool, AppSettingsLoadedActions>(_setTrue),
  TypedReducer<bool, AppSettingsNotLoadedAction>(_setFalse)
]);

bool _setTrue(bool value, BoolAction action) {
  return true;
}

bool _setFalse(bool value, BoolAction action) {
  return false;
}
