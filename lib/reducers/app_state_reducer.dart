import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/reducers/has_loaded_reducer.dart';
import 'package:time_progress_calculator/reducers/time_progress_list_reducer.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return AppState(
    hasLoaded: hasLoadedReducer(state.hasLoaded, action),
    timeProgressList: timeProgressListReducer(state.timeProgressList, action),
  );
}
