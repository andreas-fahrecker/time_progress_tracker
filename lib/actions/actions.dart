import 'package:redux/redux.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';

class LoadSettingsAction {}

class AppSettingsLoadedActions {
  final AppSettings appSettings;

  AppSettingsLoadedActions(this.appSettings);
}

class UpdateAppSettingsActions {
  final AppSettings appSettings;

  UpdateAppSettingsActions(this.appSettings);
}

class AppSettingsNotLoadedAction {}

class LoadTimeProgressListAction {}

class TimeProgressListLoadedAction {
  final List<TimeProgress> timeProgressList;

  TimeProgressListLoadedAction(this.timeProgressList);
}

class TimeProgressListNotLoadedAction {}

class AddTimeProgressAction {
  final TimeProgress timeProgress;

  AddTimeProgressAction(this.timeProgress);
}

class UpdateTimeProgressAction {
  final String id;
  final TimeProgress updatedTimeProgress;

  UpdateTimeProgressAction(this.id, this.updatedTimeProgress);
}

class DeleteTimeProgressAction {
  final String id;

  DeleteTimeProgressAction(this.id);
}

void loadTimeProgressListIfUnloaded(Store<AppState> store) {
  if (!store.state.hasProgressesLoaded)
    store.dispatch(LoadTimeProgressListAction());
}

void loadSettingsIfUnloaded(Store<AppState> store) {
  if (!store.state.hasSettingsLoaded) store.dispatch(LoadSettingsAction());
}
