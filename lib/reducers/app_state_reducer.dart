import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/reducers/timer_reducer.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return AppState(timers: timersReducer(state.timers, action));
}
