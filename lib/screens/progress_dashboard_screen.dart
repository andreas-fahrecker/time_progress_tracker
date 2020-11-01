import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_calculator/actions/actions.dart';
import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/models/time_progress.dart';
import 'package:time_progress_calculator/screens/progress_creation_screen.dart';
import 'package:time_progress_calculator/screens/progress_detail_screen.dart';
import 'package:time_progress_calculator/widgets/app_drawer_widget.dart';

class ProgressDashboardScreen extends StatelessWidget {
  static const routeName = "/progress-dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Progress Dashboard"),
      ),
      drawer: AppDrawer(),
      body: StoreConnector(
        converter: _ViewModel.fromStore,
        onInit: loadTimeProgressListIfUnloaded,
        builder: (BuildContext context, _ViewModel vm) {
          List<Widget> dashboardTileList = List<Widget>();

          if (vm.timeProgressList.length > 0) {
            for (TimeProgress tp in vm.timeProgressList) {
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
  final List<TimeProgress> timeProgressList;

  _ViewModel({@required this.timeProgressList});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(timeProgressList: store.state.timeProgressList);
  }
}
