import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';

final hasProgressesLoadedReducer = combineReducers<bool>([
  TypedReducer<bool, TimeProgressListLoadedAction>(_setProgressesLoaded).call,
  TypedReducer<bool, TimeProgressListNotLoadedAction>(_setProgressesUnloaded).call
]);

bool _setProgressesLoaded(bool hasLoaded, TimeProgressListLoadedAction action) {
  return true;
}

bool _setProgressesUnloaded(bool hasLoaded, TimeProgressListNotLoadedAction action) {
  return false;
}

final hasSettingsLoadedReducer = combineReducers<bool>([
  TypedReducer<bool, AppSettingsLoadedActions>(_setSettingsLoaded).call,
  TypedReducer<bool, AppSettingsNotLoadedAction>(_setSettingsUnloaded).call
]);

bool _setSettingsLoaded(bool hasLoaded, AppSettingsLoadedActions action) {
  return true;
}

bool _setSettingsUnloaded(bool hasLoaded, AppSettingsNotLoadedAction action) {
  return false;
}