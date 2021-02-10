import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/screens/progress_creation_screen.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';
import 'package:time_progress_tracker/widgets/home_widgets/home_bottom_navbar.dart';
import 'package:time_progress_tracker/widgets/home_widgets/home_active_progresses_tab.dart';
import 'package:time_progress_tracker/widgets/home_widgets/home_inactive_progresses_tab.dart';
import 'package:time_progress_tracker/widgets/home_widgets/home_settings_tab.dart';

class ProgressDashboardScreen extends StatefulWidget {
  static const routeName = "/progress-dashboard";
  static const title = "Time Progress Tracker";

  @override
  State<StatefulWidget> createState() {
    return _ProgressDashboardScreenState();
  }
}

class _ProgressDashboardScreenState extends State<ProgressDashboardScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeActiveProgressesTab(),
    HomeInactiveProgressesTab(),
    HomeSettingsTab(),
  ];

  void onBottomTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(ProgressDashboardScreen.title),
      ),
      body: _children[_currentIndex],
      /*
      StoreConnector(
        converter: _ViewModel.fromStore,
        onInit: loadTimeProgressListIfUnloaded,
        builder: (BuildContext context, _ViewModel vm) {
          if (!vm.hasLoaded) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Widget> startedProgressesTileList = List<Widget>();

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

          List<Widget> pastProgressesTileList = List<Widget>();
          if (vm.pastTimeProgresses.length > 0) {
            for (TimeProgress tp in vm.pastTimeProgresses) {
              pastProgressesTileList.add(
                Card(
                    child: ListTile(
                  title: Text(tp.name),
                  subtitle: Text(
                      "Ended ${DateTime.now().difference(tp.endTime).inDays} Days ago."),
                  onTap: () {
                    Navigator.pushNamed(context, ProgressDetailScreen.routeName,
                        arguments: ProgressDetailScreenArguments(tp.id));
                  },
                )),
              );
            }
          }

          double dividerHeight = 1;
          double screenHeight = MediaQuery.of(context).size.height -
              50 -
              dividerHeight -
              1; //Divider

          List<Widget> columnChildren = List<Widget>();
          int tpCount = vm.currentTimeProgresses.length +
              vm.futureTimeProgresses.length +
              vm.pastTimeProgresses.length;
          if (vm.hasCurrentProgresses) {
            columnChildren.add(Container(
              height: screenHeight - 100,
              child: ListView(
                padding: EdgeInsets.all(8),
                children: startedProgressesTileList,
              ),
            ));
          }

          if (!vm.hasCurrentProgresses &&
              !vm.hasFutureProgresses &&
              vm.pastTimeProgresses.length < 1) {
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
      )
      */
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _currentIndex != 2
          ? FloatingActionButton(
              heroTag: "createProgressBTN",
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, ProgressCreationScreen.routeName);
              },
            )
          : null,
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentIndex,
        onTap: onBottomTabTapped,
      ),
    );
  }
}

class _ViewModel {
  final List<TimeProgress> currentTimeProgresses;
  final bool hasCurrentProgresses;
  final List<TimeProgress> futureTimeProgresses;
  final bool hasFutureProgresses;
  final List<TimeProgress> pastTimeProgresses;
  final bool hasLoaded;

  _ViewModel({
    @required this.currentTimeProgresses,
    @required this.hasCurrentProgresses,
    @required this.futureTimeProgresses,
    @required this.hasFutureProgresses,
    @required this.pastTimeProgresses,
    @required this.hasLoaded,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    List<TimeProgress> currentTPList = currentTimeProgressSelector(store.state);
    List<TimeProgress> futureTPList = futureTimeProgressesSelector(store.state);
    return _ViewModel(
      currentTimeProgresses: currentTPList,
      hasCurrentProgresses: currentTPList.length > 0,
      futureTimeProgresses: futureTPList,
      hasFutureProgresses: futureTPList.length > 0,
      pastTimeProgresses: pastTimeProgressesSelector(store.state),
      hasLoaded: store.state.hasLoaded,
    );
  }
}
