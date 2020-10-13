import 'package:time_progress_calculator/models/timer.dart';

class LoadTimersAction {}

class TimersLoadedAction {
  final List<Timer> timers;

  TimersLoadedAction(this.timers);
}

class TimersNotLoadedAction {}

class AddTimerAction {
  final Timer timer;

  AddTimerAction(this.timer);
}

class UpdateTimerAction {
  final String id;
  final Timer updatedTimer;

  UpdateTimerAction(this.id, this.updatedTimer);
}

class DeleteTimerAction {
  final String id;

  DeleteTimerAction(this.id);
}
