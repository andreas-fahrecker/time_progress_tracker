import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/persistence/app_settings.dart';
import 'package:time_progress_tracker/persistence/time_progress_entity.dart';
import 'package:time_progress_tracker/persistence/time_progress_repository.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';

List<Middleware<AppState>> createStoreMiddleware(
    TimeProgressRepository progressRepo, AppSettingsRepository settingsRepo) {
  final saveTimeProgressList = _createSaveTimeProgressList(progressRepo);
  final loadTimeProgressList = _createLoadTimeProgressList(progressRepo);

  final saveSettings = _createSaveAppSettings(settingsRepo);
  final loadSettings = _createLoadAppSettings(settingsRepo);

  return [
    TypedMiddleware<AppState, LoadTimeProgressListAction>(loadTimeProgressList).call,
    TypedMiddleware<AppState, AddTimeProgressAction>(saveTimeProgressList).call,
    TypedMiddleware<AppState, UpdateTimeProgressAction>(saveTimeProgressList).call,
    TypedMiddleware<AppState, DeleteTimeProgressAction>(saveTimeProgressList).call,
    TypedMiddleware<AppState, LoadSettingsAction>(loadSettings).call,
    TypedMiddleware<AppState, UpdateAppSettingsActions>(saveSettings).call
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
      store.dispatch(TimeProgressListLoadedAction(
        timeProgressList,
      ));
    }).catchError((_) => store.dispatch(TimeProgressListNotLoadedAction()));
  };
}

Middleware<AppState> _createSaveAppSettings(AppSettingsRepository repo) =>
    (Store<AppState> store, dynamic action, NextDispatcher next) {
      next(action);
      repo.saveAppSettings(store.state.appSettings.toEntity());
    };

Middleware<AppState> _createLoadAppSettings(AppSettingsRepository repo) =>
    (Store<AppState> store, dynamic action, NextDispatcher next) {
      repo.loadAppSettings().then((appSettings) {
        store.dispatch(
            AppSettingsLoadedActions(AppSettings.fromEntity(appSettings)));
      });
    };
