import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';
import 'package:time_progress_tracker/widgets/home_widgets/home_progress_list_tile.dart';

class HomeActiveProgressesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    return StoreConnector(
        converter: _ViewModel.fromStore,
        onInit: loadTimeProgressListIfUnloaded,
        builder: (BuildContext scContext, _ViewModel vm) {
          if (!vm.hasLoaded)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (vm.activeTimeProgresses.length < 1)
            return Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                    "You don't have any currently active time progresses, that are tracked."),
              ),
            );
          return ListView(
            padding: EdgeInsets.all(8),
            children: vm.activeTimeProgresses
                .map((timeProgress) => HomeProgressListTile(
                      timeProgress: timeProgress,
                    ))
                .toList(),
          );
        });
  }
}

class _ViewModel {
  final List<TimeProgress> activeTimeProgresses;
  final bool hasLoaded;

  _ViewModel({
    @required this.activeTimeProgresses,
    @required this.hasLoaded,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      activeTimeProgresses: activeTimeProgressesSelector(store.state),
      hasLoaded: store.state.hasLoaded,
    );
  }
}
