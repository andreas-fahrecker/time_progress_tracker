import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/redux/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/utils/helper_functions.dart';

class TimeProgressListStoreConnector extends StatelessWidget {
  final Widget Function(BuildContext, TimeProgressListViewModel) loadedBuilder;

  TimeProgressListStoreConnector({
    required this.loadedBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TimeProgressListViewModel>(
      onInit: loadTimeProgressListIfUnloaded,
      converter: (store) => TimeProgressListViewModel._create(store),
      builder: (context, TimeProgressListViewModel vm) {
        if (!vm.hasTpListLoaded)
          return Center(
            child: CircularProgressIndicator(),
          );
        return loadedBuilder(context, vm);
      },
    );
  }
}

class TimeProgressListViewModel {
  final List<TimeProgress> tpList;
  final bool hasTpListLoaded;

  TimeProgressListViewModel(this.tpList, this.hasTpListLoaded);

  factory TimeProgressListViewModel._create(Store<AppState> store) =>
      TimeProgressListViewModel(
          store.state.timeProgressList, store.state.hasProgressesLoaded);
}
