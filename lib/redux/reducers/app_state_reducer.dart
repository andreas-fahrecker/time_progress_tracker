import 'package:time_progress_tracker/redux/app_state.dart';
import 'package:time_progress_tracker/redux/reducers/bool_reducers.dart';
import 'package:time_progress_tracker/redux/reducers/model_reducers.dart';

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
