import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/redux/actions/redux_actions.dart';

class LoadAppSettingsAction {}

class AppSettingsLoadedActions extends AppSettingsAction with BoolAction {
  AppSettingsLoadedActions(AppSettings appSettings) : super(appSettings);
}

class UpdateAppSettingsActions extends AppSettingsAction {
  UpdateAppSettingsActions(AppSettings appSettings) : super(appSettings);
}

class AppSettingsNotLoadedAction extends BoolAction {}
