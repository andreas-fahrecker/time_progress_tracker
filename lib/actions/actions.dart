import 'package:redux/redux.dart';
import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/models/time_progress.dart';

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
  if (!store.state.hasLoaded) {
    store.dispatch(LoadTimeProgressListAction());
  }
}
