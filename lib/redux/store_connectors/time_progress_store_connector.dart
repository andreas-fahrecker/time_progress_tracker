import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/redux/actions/time_progress_actions.dart';
import 'package:time_progress_tracker/redux/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';

import '../../utils/helper_functions.dart';

class TimeProgressStoreConnector extends StatelessWidget {
  final String timeProgressId;
  final Widget Function(BuildContext, TimeProgressViewModel) loadedBuilder;

  TimeProgressStoreConnector({
    @required this.timeProgressId,
    @required this.loadedBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TimeProgressViewModel>(
      onInit: loadTimeProgressListIfUnloaded,
      converter: (store) =>
          TimeProgressViewModel._create(store, timeProgressId),
      builder: (context, TimeProgressViewModel vm) {
        if (!vm.hasTpListLoaded)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (vm.tp == null)
          return Center(
            child: Text("Error Invalid Time Progress"),
          );
        return loadedBuilder(context, vm);
      },
    );
  }
}

class TimeProgressViewModel {
  final TimeProgress tp;
  final bool hasTpListLoaded;

  final void Function(TimeProgress) updateTimeProgress;
  final void Function() deleteTimeProgress;

  TimeProgressViewModel(
    this.tp,
    this.hasTpListLoaded,
    this.updateTimeProgress,
    this.deleteTimeProgress,
  );

  factory TimeProgressViewModel._create(Store<AppState> store, String id) {
    void _updateTimeProgress(TimeProgress tp) =>
        store.dispatch(UpdateTimeProgressAction(id, tp));
    void _deleteTimeProgress() => store.dispatch(DeleteTimeProgressAction(id));

    return TimeProgressViewModel(
      selectProgressById(store.state.timeProgressList, id),
      store.state.hasProgressesLoaded,
      _updateTimeProgress,
      _deleteTimeProgress,
    );
  }
}
