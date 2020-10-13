import 'package:time_progress_calculator/actions/timer_actions.dart';
import 'package:time_progress_calculator/models/timer.dart';
import 'package:redux/redux.dart';

final timersReducer = combineReducers<List<Timer>>([
  TypedReducer<List<Timer>, TimersLoadedAction>(_setLoadedTimers),
  TypedReducer<List<Timer>, TimersNotLoadedAction>(_setEmptyTimers),
  TypedReducer<List<Timer>, AddTimerAction>(_addTimer),
  TypedReducer<List<Timer>, UpdateTimerAction>(_updateTimer),
  TypedReducer<List<Timer>, DeleteTimerAction>(_deleteTimer),
]);

List<Timer> _setLoadedTimers(List<Timer> timers, TimersLoadedAction action) {
  return action.timers;
}

List<Timer> _setEmptyTimers(List<Timer> timers, TimersNotLoadedAction action) {
  return [];
}

List<Timer> _addTimer(List<Timer> timers, AddTimerAction action) {
  return List.from(timers, growable: false)..add(action.timer);
}

List<Timer> _updateTimer(List<Timer> timers, UpdateTimerAction action) {
  return timers
      .map((timer) => timer.id == action.id ? action.updatedTimer : timer)
      .toList(growable: false);
}

List<Timer> _deleteTimer(List<Timer> timers, DeleteTimerAction action) {
  return timers.where((timer) => timer.id != action.id).toList(growable: false);
}
