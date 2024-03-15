import 'dart:ui';

import 'package:time_progress_tracker/models/time_progress.dart';

TimeProgress selectProgressById(List<TimeProgress> tpList, String id) =>
    tpList.firstWhere((tp) => tp.id == id, orElse: () => TimeProgress.initialDefault());

List<TimeProgress> selectActiveProgresses(List<TimeProgress> tpList) =>
    tpList.where((tp) => tp.hasStarted() && !tp.hasEnded()).toList();

List<TimeProgress> selectInactiveProgresses(List<TimeProgress> tpList) =>
    tpList.where((tp) => !tp.hasStarted() || tp.hasEnded()).toList();

bool useBrightBackground(Color bC) {
  double yiq = ((bC.red * 299) + (bC.green * 587) + (bC.blue * 114)) / 1000;
  return yiq >= 186 || (bC.red == 0 && bC.green == 0 && bC.blue == 0);
}
