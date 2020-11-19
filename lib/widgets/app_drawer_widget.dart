import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/screens/progress_dashboard_screen.dart';
import 'package:time_progress_tracker/screens/progress_detail_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StoreConnector(
        converter: _ViewModel.fromStore,
        onInit: loadTimeProgressListIfUnloaded,
        builder: (context, _ViewModel vm) {
          List<Widget> drawerTileList = List<Widget>();
          drawerTileList.add(DrawerHeader(
            child: Text("Select Time Progress"),
            decoration: BoxDecoration(color: Colors.blue),
            margin: EdgeInsets.zero,
          ));
          drawerTileList.add(Container(
            color: Colors.lightBlue,
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text("Time Progress Dashboard"),
              trailing: Icon(Icons.dashboard),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, ProgressDashboardScreen.routeName);
              },
            ),
          ));
          if (vm.timeProgressList.length > 0) {
            for (TimeProgress tp in vm.timeProgressList) {
              drawerTileList.add(ListTile(
                title: Text(tp.name),
                trailing: CircularPercentIndicator(
                  percent: tp.percentDone(),
                  radius: 40,
                  progressColor: Colors.green,
                  backgroundColor: Colors.red,
                  center: FittedBox(
                    fit: BoxFit.scaleDown,
                    child:
                        Text((tp.percentDone() * 100).floor().toString() + "%"),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    ProgressDetailScreen.routeName,
                    arguments: ProgressDetailScreenArguments(tp.id),
                  );
                },
              ));
              if (vm.timeProgressList.last != tp) {
                drawerTileList.add(Divider(
                  color: Colors.black12,
                ));
              }
            }
          } else {
            drawerTileList.add(ListTile(
              title: Text("You don't have any tracked time progress."),
            ));
          }
          return ListView(
            children: drawerTileList,
          );
        },
      ),
    );
  }
}

class _ViewModel {
  final List<TimeProgress> timeProgressList;

  _ViewModel({@required this.timeProgressList});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      timeProgressList: store.state.timeProgressList,
    );
  }
}
