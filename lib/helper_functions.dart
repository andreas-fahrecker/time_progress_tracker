import 'package:time_progress_tracker/models/time_progress.dart';

TimeProgress selectProgressById(List<TimeProgress> tpList, String id) =>
    tpList.firstWhere((tp) => tp.id == id, orElse: null);

List<TimeProgress> selectActiveProgresses(List<TimeProgress> tpList) =>
    tpList.where((tp) => tp.hasStarted() && !tp.hasEnded()).toList();

List<TimeProgress> selectInactiveProgresses(List<TimeProgress> tpList) =>
    tpList.where((tp) => !tp.hasStarted() || tp.hasEnded()).toList();
