import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/time_progress.dart';

abstract class BoolAction {}

abstract class AppSettingsAction {
  final AppSettings appSettings;

  AppSettingsAction(this.appSettings);
}

abstract class TimeProgressAction {
  final TimeProgress timeProgress;

  TimeProgressAction(this.timeProgress);
}
