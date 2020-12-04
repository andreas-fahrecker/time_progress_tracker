import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';

List<TimeProgress> timeProgressListSelector(AppState state) =>
    state.timeProgressList;

List<TimeProgress> startedTimeProgressesSelector(AppState state) =>
    state.timeProgressList
        .where((timeProgress) =>
            DateTime.now().millisecondsSinceEpoch >=
            timeProgress.startTime.millisecondsSinceEpoch)
        .toList();

List<TimeProgress> futureTimeProgressesSelector(AppState state) =>
    state.timeProgressList
        .where((timeProgress) =>
            DateTime.now().millisecondsSinceEpoch <
            timeProgress.startTime.millisecondsSinceEpoch)
        .toList();

TimeProgress timeProgressByIdSelector(AppState state, String id) {
  if (state.timeProgressList.length < 1) return null;
  return state.timeProgressList
      .firstWhere((timeProgress) => timeProgress.id == id);
}
