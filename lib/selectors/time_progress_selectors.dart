import 'dart:ui';

import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';

List<TimeProgress> timeProgressListSelector(AppState state) =>
    state.timeProgressList;

List<TimeProgress> activeTimeProgressesSelector(AppState state) {
  return state.timeProgressList
      .where((timeProgress) =>
          timeProgress.hasStarted() && !timeProgress.hasEnded())
      .toList();
}

List<TimeProgress> inactiveTimeProgressesSelector(AppState state) {
  return state.timeProgressList
      .where((timeProgress) =>
          !timeProgress.hasStarted() || timeProgress.hasEnded())
      .toList();
}

@Deprecated("use active TimeProgresses Selector instead.")
List<TimeProgress> currentTimeProgressSelector(AppState state) {
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  return state.timeProgressList
      .where((tp) =>
          currentTime >= tp.startTime.millisecondsSinceEpoch &&
          tp.endTime.millisecondsSinceEpoch >= currentTime)
      .toList();
}

List<TimeProgress> futureTimeProgressesSelector(AppState state) =>
    state.timeProgressList
        .where((timeProgress) =>
            DateTime.now().millisecondsSinceEpoch <
            timeProgress.startTime.millisecondsSinceEpoch)
        .toList();

List<TimeProgress> pastTimeProgressesSelector(AppState state) =>
    state.timeProgressList
        .where((tp) =>
            tp.endTime.millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch)
        .toList();

TimeProgress? timeProgressByIdSelector(AppState state, String id) {
  if (state.timeProgressList.isEmpty) return null;
  return state.timeProgressList.firstWhere(
      (timeProgress) => timeProgress.id == id,
      orElse: () => TimeProgress.initialDefault());
}

AppSettings appSettingsSelector(AppState state) {
  return state.appSettings;
}

Color doneColorSelector(AppState state) => state.appSettings.doneColor;
