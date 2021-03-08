import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';

class SettingsStoreConnector extends StatelessWidget {
  final Widget Function(BuildContext, SettingsViewModel) loadedBuilder;

  SettingsStoreConnector({
    @required this.loadedBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingsViewModel>(
      onInit: loadSettingsIfUnloaded,
      converter: (store) => SettingsViewModel._create(store),
      builder: (context, SettingsViewModel vm) {
        if (!vm.hasSettingsLoaded)
          return Center(
            child: CircularProgressIndicator(),
          );
        return loadedBuilder(context, vm);
      },
    );
  }
}

class SettingsViewModel {
  final AppSettings appSettings;
  final bool hasSettingsLoaded;

  SettingsViewModel(this.appSettings, this.hasSettingsLoaded);

  factory SettingsViewModel._create(Store<AppState> store) =>
      SettingsViewModel(store.state.appSettings, store.state.hasSettingsLoaded);
}
