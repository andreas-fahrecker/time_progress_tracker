import 'package:time_progress_tracker/models/time_progress.dart';

List<TimeProgress> selectActiveProgresses(List<TimeProgress> tpList) =>
    tpList.where((tp) => tp.hasStarted() && !tp.hasEnded()).toList();
