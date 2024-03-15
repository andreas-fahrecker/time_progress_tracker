import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';

class SettingsStoreConnector extends StatelessWidget {
  final Widget Function(BuildContext, SettingsViewModel) loadedBuilder;

  const SettingsStoreConnector({
    super.key,
    @required this.loadedBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingsViewModel>(
      onInit: loadSettingsIfUnloaded,
      converter: (store) => SettingsViewModel._create(store),
      builder: (context, SettingsViewModel vm) {
        if (!vm.hasSettingsLoaded) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return loadedBuilder(context, vm);
      },
    );
  }
}

class SettingsViewModel {
  final AppSettings appSettings;
  final bool hasSettingsLoaded;

  final void Function(Color) updateDoneColor, updateLeftColor;
  final void Function(Duration) updateDuration;

  SettingsViewModel(
    this.appSettings,
    this.hasSettingsLoaded,
    this.updateDoneColor,
    this.updateLeftColor,
    this.updateDuration,
  );

  factory SettingsViewModel._create(Store<AppState> store) {
    AppSettings appSettings = store.state.appSettings;

    void updateDoneColor(Color dC) => store.dispatch(
        UpdateAppSettingsActions(appSettings.copyWith(doneColor: dC)));
    void updateLeftColor(Color lC) => store.dispatch(
        UpdateAppSettingsActions(appSettings.copyWith(leftColor: lC)));

    void updateDuration(Duration d) => store
        .dispatch(UpdateAppSettingsActions(appSettings.copyWith(duration: d)));

    return SettingsViewModel(appSettings, store.state.hasSettingsLoaded,
        updateDoneColor, updateLeftColor, updateDuration);
  }
}
