import 'package:time_progress_calculator/actions/timer_actions.dart';
import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/reducers/timer_reducer.dart';

AppState appReducer(AppState state, Action action) {
  return AppState(timer: timersReducer(state.timer, action));
}
