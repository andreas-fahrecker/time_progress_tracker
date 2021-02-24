import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/reducers/has_loaded_reducer.dart';
import 'package:time_progress_tracker/reducers/time_progress_list_reducer.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return AppState(
    hasProgressesLoaded: hasLoadedReducer(state.hasProgressesLoaded, action),
    timeProgressList: timeProgressListReducer(state.timeProgressList, action),
  );
}

final appSettingsReducers = combineReducers<AppSettings>([
  TypedReducer<AppSettings, AppSettingsLoadedActions>(_loadAppSettings),
  TypedReducer<AppSettings, UpdateAppSettingsActions>(_updateAppSettings)
]);

AppSettings _loadAppSettings(
        AppSettings appSettings, AppSettingsLoadedActions nS) =>
    nS.appSettings;

AppSettings _updateAppSettings(
        AppSettings appSettings, UpdateAppSettingsActions nS) =>
    nS.appSettings;
