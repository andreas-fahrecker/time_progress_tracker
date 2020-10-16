import 'package:redux/redux.dart';
import 'package:time_progress_calculator/actions/actions.dart';
import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/models/time_progress.dart';
import 'package:time_progress_calculator/persistence/time_progress_entity.dart';
import 'package:time_progress_calculator/persistence/time_progress_repository.dart';
import 'package:time_progress_calculator/selectors/time_progress_selectors.dart';

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

Middleware<AppState> _createSaveTimeProgressList(TimeProgressRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    repository.saveTimeProgressList(
      timeProgressListSelector(store.state)
          .map<TimeProgressEntity>((timeProgress) => timeProgress.toEntity())
          .toList(growable: false),
    );
  };
}

Middleware<AppState> _createLoadTimeProgressList(TimeProgressRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository.loadTimeProgressList().then((timeProgresses) {
      store.dispatch(
        TimeProgressListLoadedAction(timeProgresses.map<TimeProgress>(TimeProgress.fromEntity).toList()),
      );
    }).catchError((_) => store.dispatch(TimeProgressListNotLoadedAction()));
  };
}
