import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/redux/actions/redux_actions.dart';

class LoadTimeProgressListAction {}

class TimeProgressListLoadedAction extends BoolAction {
  final List<TimeProgress> timeProgressList;

  TimeProgressListLoadedAction(this.timeProgressList);
}

class TimeProgressListNotLoadedAction extends BoolAction {}

class AddTimeProgressAction extends TimeProgressAction {
  AddTimeProgressAction(TimeProgress timeProgress) : super(timeProgress);
}

class UpdateTimeProgressAction extends TimeProgressAction {
  final String id;

  UpdateTimeProgressAction(this.id, TimeProgress timeProgress)
      : super(timeProgress);
}

class DeleteTimeProgressAction {
  final String id;

  DeleteTimeProgressAction(this.id);
}
