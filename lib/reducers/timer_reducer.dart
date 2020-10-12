import 'package:time_progress_calculator/actions/timer_actions.dart';
import 'package:time_progress_calculator/models/timer.dart';
import 'package:redux/redux.dart';

final timersReducer = combineReducers<Timer>(
    [TypedReducer<Timer, UpdateTimerAction>(_updateTimer)]);

Timer _updateTimer(Timer timer, UpdateTimerAction action) {
  return action.updatedTimer;
}
