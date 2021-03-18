import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/redux/actions/time_progress_actions.dart';
import 'package:time_progress_tracker/redux/app_state.dart';
import 'package:time_progress_tracker/redux/redux_selectors.dart';

import '../../utils/helper_functions.dart';

class CreateTimeProgressStoreConnector extends StatelessWidget {
  final Widget Function(BuildContext, CreateTimeProgressViewModel)
      loadedBuilder;

  CreateTimeProgressStoreConnector({
    required this.loadedBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateTimeProgressViewModel>(
      onInit: loadTimeProgressListIfUnloaded,
      converter: (store) => CreateTimeProgressViewModel._create(store),
      builder: (context, CreateTimeProgressViewModel vm) {
        return loadedBuilder(context, vm);
      },
    );
  }
}

class CreateTimeProgressViewModel {
  final TimeProgress defaultProgress;

  final void Function(TimeProgress) addTimeProgress;

  CreateTimeProgressViewModel(
    this.defaultProgress,
    this.addTimeProgress,
  );

  factory CreateTimeProgressViewModel._create(Store<AppState> store) {
    AppSettings settings = appSettingsSelector(store.state);
    void _addTimeProgress(TimeProgress tp) {
      if (TimeProgress.isValid(tp)) store.dispatch(AddTimeProgressAction(tp));
    }

    return CreateTimeProgressViewModel(
      TimeProgress.defaultFromDuration(settings.duration),
      _addTimeProgress,
    );
  }
}
