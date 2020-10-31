import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/models/time_progress.dart';

List<TimeProgress> timeProgressListSelector(AppState state) =>
    state.timeProgressList;

TimeProgress timeProgressByIdSelector(AppState state, String id) =>
    state.timeProgressList.firstWhere((timeProgress) => timeProgress.id == id);