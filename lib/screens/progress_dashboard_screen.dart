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

  final String appVersion;

  ProgressDashboardScreen({
    Key key,
    @required this.appVersion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(title),
    );

    return Scaffold(
      appBar: appBar,
      drawer: AppDrawer(
        appVersion: appVersion,
      ),
      body: StoreConnector(
        converter: _ViewModel.fromStore,
        onInit: loadTimeProgressListIfUnloaded,
        builder: (BuildContext context, _ViewModel vm) {
          if (!vm.hasLoaded) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Widget> startedProgressesTileList = List<Widget>();
          if (vm.hasStartedProgresses) {
            for (TimeProgress tp in vm.startedTimeProgreses) {
              startedProgressesTileList.add(
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
          }

          List<Widget> futureProgressesTileList = List<Widget>();
          if (vm.hasFutureProgresses) {
            for (TimeProgress tp in vm.futureTimeProgresses) {
              futureProgressesTileList.add(
                Card(
                  child: ListTile(
                    title: Text(tp.name),
                    subtitle: Text(
                        "Starts in ${tp.startTime.difference(DateTime.now()).inDays} Days."),
                    onTap: () {
                      Navigator.pushNamed(
                          context, ProgressDetailScreen.routeName,
                          arguments: ProgressDetailScreenArguments(tp.id));
                    },
                  ),
                ),
              );
            }
          }

          double dividerHeight = 1;
          double screenHeight = MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              24 -
              dividerHeight; //Divider

          List<Widget> columnChildren = List<Widget>();
          int tpCount =
              vm.startedTimeProgreses.length + vm.futureTimeProgresses.length;
          if (vm.hasStartedProgresses) {
            columnChildren.add(Container(
              height: vm.hasFutureProgresses
                  ? (screenHeight / tpCount) * vm.startedTimeProgreses.length
                  : screenHeight,
              child: ListView(
                padding: EdgeInsets.all(8),
                children: startedProgressesTileList,
              ),
            ));
          }
          if (vm.hasStartedProgresses && vm.hasFutureProgresses) {
            columnChildren.add(Divider(
              height: dividerHeight,
            ));
          }
          if (vm.hasFutureProgresses) {
            columnChildren.add(Container(
              height: vm.hasStartedProgresses
                  ? (screenHeight / tpCount) * vm.futureTimeProgresses.length
                  : screenHeight,
              child: ListView(
                padding: EdgeInsets.all(8),
                children: futureProgressesTileList,
              ),
            ));
          }

          if (!vm.hasStartedProgresses && !vm.hasFutureProgresses) {
            columnChildren.add(Container(
              margin: EdgeInsets.all(16),
              child: Center(
                child: Text("You don't have any tracked Progress."),
              ),
            ));
          }

          return Column(
            children: columnChildren,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "createProgressBTN",
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
  final bool hasStartedProgresses;
  final List<TimeProgress> futureTimeProgresses;
  final bool hasFutureProgresses;
  final bool hasLoaded;

  _ViewModel({
    @required this.startedTimeProgreses,
    @required this.hasStartedProgresses,
    @required this.futureTimeProgresses,
    @required this.hasFutureProgresses,
    @required this.hasLoaded,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    List<TimeProgress> startedTPList =
        startedTimeProgressesSelector(store.state);
    List<TimeProgress> furtureTPList =
        futureTimeProgressesSelector(store.state);
    return _ViewModel(
      startedTimeProgreses: startedTPList,
      hasStartedProgresses: startedTPList.length > 0,
      futureTimeProgresses: furtureTPList,
      hasFutureProgresses: furtureTPList.length > 0,
      hasLoaded: store.state.hasLoaded,
    );
  }
}
