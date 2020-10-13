import 'package:redux/redux.dart';
import 'package:time_progress_calculator/actions/timer_actions.dart';
import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/models/timer.dart';
import 'package:time_progress_calculator/persistence/timer_entity.dart';
import 'package:time_progress_calculator/persistence/timers_repository.dart';
import 'package:time_progress_calculator/selectors/timer_selectors.dart';

List<Middleware<AppState>> createStoreTimersMiddleware(
    TimersRepository repository) {
  final saveTimers = _createSaveTimers(repository);
  final loadTimers = _createLoadTimers(repository);

  return [
    TypedMiddleware<AppState, LoadTimersAction>(loadTimers),
    TypedMiddleware<AppState, AddTimerAction>(saveTimers),
    TypedMiddleware<AppState, UpdateTimerAction>(saveTimers),
    TypedMiddleware<AppState, DeleteTimerAction>(saveTimers),
  ];
}

Middleware<AppState> _createSaveTimers(TimersRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    repository.saveTimers(
      timersSelector(store.state)
          .map<TimerEntity>((timer) => timer.toEntity())
          .toList(growable: false),
    );
  };
}

Middleware<AppState> _createLoadTimers(TimersRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository.loadTimers().then((timers) {
      store.dispatch(
        TimersLoadedAction(timers.map<Timer>(Timer.fromEntity).toList()),
      );
    }).catchError((_) => store.dispatch(TimersNotLoadedAction()));
  };
}
