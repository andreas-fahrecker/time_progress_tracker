import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/persistence/app_settings.dart';

List<Middleware<AppState>> createStoreAppSettingsMiddleware(
    AppSettingsRepository repo) {

}

Middleware<AppState> _createSaveAppState(AppSettingsRepository repo) =>
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
