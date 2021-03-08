import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';

final hasProgressesLoadedReducer = combineReducers<bool>([
  TypedReducer<bool, TimeProgressListLoadedAction>(_setProgressesLoaded),
  TypedReducer<bool, TimeProgressListNotLoadedAction>(_setProgressesUnloaded)
]);

bool _setProgressesLoaded(bool hasLoaded, TimeProgressListLoadedAction action) {
  return true;
}

bool _setProgressesUnloaded(bool hasLoaded, TimeProgressListNotLoadedAction action) {
  return false;
}

final hasSettingsLoadedReducer = combineReducers<bool>([
  TypedReducer<bool, AppSettingsLoadedActions>(_setSettingsLoaded),
  TypedReducer<bool, AppSettingsNotLoadedAction>(_setSettingsUnloaded)
]);

bool _setSettingsLoaded(bool hasLoaded, AppSettingsLoadedActions action) {
  return true;
}

bool _setSettingsUnloaded(bool hasLoaded, AppSettingsNotLoadedAction action) {
  return false;
}