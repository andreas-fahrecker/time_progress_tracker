import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/persistence/time_progress_entity.dart';
import 'package:time_progress_tracker/persistence/time_progress_repository.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';

List<Middleware<AppState>> createStoreTimeProgressListMiddleware(
    TimeProgressRepository repository) {
  final saveTimeProgressList = _createSaveTimeProgressList(repository);
  final loadTimeProgressList = _createLoadTimeProgressList(repository);

  return [
    TypedMiddleware<AppState, LoadTimeProgressListAction>(loadTimeProgressList),
    TypedMiddleware<AppState, AddTimeProgressAction>(saveTimeProgressList),
    TypedMiddleware<AppState, UpdateTimeProgressAction>(saveTimeProgressList),
    TypedMiddleware<AppState, DeleteTimeProgressAction>(saveTimeProgressList),
  ];
}

Middleware<AppState> _createSaveTimeProgressList(
    TimeProgressRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    repository.saveTimeProgressList(
      timeProgressListSelector(store.state)
          .map<TimeProgressEntity>((timeProgress) => timeProgress.toEntity())
          .toList(growable: false),
    );
  };
}

Middleware<AppState> _createLoadTimeProgressList(
    TimeProgressRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository.loadTimeProgressList().then((timeProgresses) {
      List<TimeProgress> timeProgressList =
          timeProgresses.map<TimeProgress>(TimeProgress.fromEntity).toList();
      if (timeProgressList == null) {
        timeProgressList = [];
      }
      store.dispatch(TimeProgressListLoadedAction(
        timeProgressList,
      ));
    }).catchError((_) => {store.dispatch(TimeProgressListNotLoadedAction())});
  };
}
