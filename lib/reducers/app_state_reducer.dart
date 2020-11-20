import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/reducers/has_loaded_reducer.dart';
import 'package:time_progress_tracker/reducers/time_progress_list_reducer.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return AppState(
    hasLoaded: hasLoadedReducer(state.hasLoaded, action),
    timeProgressList: timeProgressListReducer(state.timeProgressList, action),
  );
}
