import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/redux/app_state.dart';
import 'package:time_progress_tracker/reducers/has_loaded_reducer.dart';
import 'package:time_progress_tracker/reducers/time_progress_list_reducer.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return AppState(
    hasSettingsLoaded:
        hasSettingsLoadedReducer(state.hasSettingsLoaded, action),
    hasProgressesLoaded:
        hasProgressesLoadedReducer(state.hasProgressesLoaded, action),
    timeProgressList: timeProgressListReducer(state.timeProgressList, action),
    appSettings: appSettingsReducers(state.appSettings, action),
  );
}

final appSettingsReducers = combineReducers<AppSettings>([
  TypedReducer<AppSettings, AppSettingsLoadedActions>(_loadAppSettings),
  TypedReducer<AppSettings, UpdateAppSettingsActions>(_updateAppSettings),
  TypedReducer<AppSettings, AppSettingsNotLoadedAction>(_setDefaultSettings)
]);

AppSettings _loadAppSettings(
        AppSettings appSettings, AppSettingsLoadedActions nS) =>
    nS.appSettings;

AppSettings _setDefaultSettings(
        AppSettings appSettings, AppSettingsNotLoadedAction action) =>
    AppSettings.defaults();

AppSettings _updateAppSettings(
        AppSettings appSettings, UpdateAppSettingsActions nS) =>
    nS.appSettings;
