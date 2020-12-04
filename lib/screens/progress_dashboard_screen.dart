import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/screens/progress_creation_screen.dart';
import 'package:time_progress_tracker/screens/progress_detail_screen.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';
import 'package:time_progress_tracker/widgets/app_drawer_widget.dart';

class ProgressDashboardScreen extends StatelessWidget {
  static const routeName = "/progress-dashboard";
  static const title = "Time Progress Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: AppDrawer(),
      body: StoreConnector(
        converter: _ViewModel.fromStore,
        onInit: loadTimeProgressListIfUnloaded,
        builder: (BuildContext context, _ViewModel vm) {
          if (!vm.hasLoaded) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Widget> dashboardTileList = List<Widget>();

          if (vm.startedTimeProgreses.length > 0) {
            for (TimeProgress tp in vm.startedTimeProgreses) {
              dashboardTileList.add(
                Card(
                  child: ListTile(
                    title: Text(tp.name),
                    subtitle: LinearPercentIndicator(
                      center: Text("${(tp.percentDone() * 100).floor()} %"),
                      percent: tp.percentDone(),
                      progressColor: Colors.green,
                      backgroundColor: Colors.red,
                      lineHeight: 20,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context, ProgressDetailScreen.routeName,
                          arguments: ProgressDetailScreenArguments(tp.id));
                    },
                  ),
                ),
              );
            }
          } else {
            dashboardTileList.add(ListTile(
              title: Text("You don't have any tracked Progress."),
            ));
          }

          return ListView(
            padding: EdgeInsets.all(8),
            children: dashboardTileList,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, ProgressCreationScreen.routeName);
        },
      ),
    );
  }
}

class _ViewModel {
  final List<TimeProgress> startedTimeProgreses;
  final List<TimeProgress> futureTimeProgresses;
  final bool hasLoaded;

  _ViewModel({
    @required this.startedTimeProgreses,
    @required this.futureTimeProgresses,
    @required this.hasLoaded,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      startedTimeProgreses: startedTimeProgressesSelector(store.state),
      futureTimeProgresses: futureTimeProgressesSelector(store.state),
      hasLoaded: store.state.hasLoaded,
    );
  }
}
