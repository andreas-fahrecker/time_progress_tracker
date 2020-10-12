import 'package:time_progress_calculator/models/timer.dart';

abstract class Action {}

class UpdateTimerAction extends Action {
  final Timer updatedTimer;

  UpdateTimerAction(this.updatedTimer);
}