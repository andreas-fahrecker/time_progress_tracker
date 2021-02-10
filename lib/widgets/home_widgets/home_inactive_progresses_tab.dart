import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';
import 'package:time_progress_tracker/widgets/home_widgets/home_progress_list_tile.dart';

class HomeInactiveProgressesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    // TODO: implement build
    return StoreConnector(
        converter: _ViewModel.fromStore,
        onInit: loadTimeProgressListIfUnloaded,
        builder: (BuildContext scContext, _ViewModel vm) {
          if (!vm.hasLoaded)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (vm.inactiveTimeProgresses.length < 1)
            return Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                    "You don't have any currently inactive time progresses, that are tracked."),
              ),
            );
          return ListView(
            padding: EdgeInsets.all(8),
            children: vm.inactiveTimeProgresses
                .map((timeProgress) =>
                    HomeProgressListTile(timeProgress: timeProgress))
                .toList(),
          );
        });
    return Container(
      child: Text("Inactive Progresses"),
    );
  }
}

class _ViewModel {
  final List<TimeProgress> inactiveTimeProgresses;
  final bool hasLoaded;

  _ViewModel({
    @required this.inactiveTimeProgresses,
    @required this.hasLoaded,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      inactiveTimeProgresses: inactiveTimeProgressesSelector(store.state),
      hasLoaded: store.state.hasLoaded,
    );
  }
}
