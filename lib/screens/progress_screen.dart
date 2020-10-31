import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_calculator/actions/actions.dart';
import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/models/time_progress.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key key, @required this.context, this.name})
      : super(key: key);

  final BuildContext context;
  final String name;

  @override
  State<StatefulWidget> createState() {
    return _ProgressScreenState();
  }
}

class _ProgressScreenState extends State<ProgressScreen> {
  void _selectStartDate(BuildContext context) async {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: store.state.timeProgressList[0].startTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != store.state.timeProgressList[0].startTime) {
      store.dispatch(UpdateTimeProgressAction(
        store.state.timeProgressList[0].id,
        store.state.timeProgressList[0].copyWith(startTime: picked),
      ));
    }
  }

  void _selectEndDate(BuildContext context) async {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: store.state.timeProgressList[0].endTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != store.state.timeProgressList[0].endTime) {
      store.dispatch(UpdateTimeProgressAction(
        store.state.timeProgressList[0].id,
        store.state.timeProgressList[0].copyWith(endTime: picked),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    if (StoreProvider.of<AppState>(widget.context)
            .state
            .timeProgressList
            .length <
        1) {
      StoreProvider.of<AppState>(widget.context).dispatch(AddTimeProgressAction(
        TimeProgress(
          widget.name,
          DateTime(2000),
          DateTime(2100),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.name} Progress"),
      ),
      body: StoreConnector(
          converter: _ViewModel.fromStore,
          builder: (context, _ViewModel vm) {
            final int daysDone =
                DateTime.now().difference(vm.timeProgress.startTime).inDays;
            final int daysLeft =
                vm.timeProgress.endTime.difference(DateTime.now()).inDays;
            final int allDays = vm.timeProgress.endTime
                .difference(vm.timeProgress.startTime)
                .inDays;
            final double percent = daysDone / (allDays / 100) / 100;

            return Container(
              margin: const EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Start Date:",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text("${vm.timeProgress.startTime.toLocal()}"
                              .split(" ")[0]),
                        ),
                        Expanded(
                          flex: 2,
                          child: RaisedButton(
                            onPressed: () => _selectStartDate(context),
                            child: Text("Change"),
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        Spacer(flex: 1)
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            "End Date:",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text("${vm.timeProgress.endTime.toLocal()}"
                              .split(" ")[0]),
                        ),
                        Expanded(
                          flex: 2,
                          child: RaisedButton(
                            onPressed: () => _selectEndDate(context),
                            child: Text("Change"),
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        Spacer(flex: 1)
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: CircularPercentIndicator(
                      radius: 100,
                      lineWidth: 10,
                      percent: percent,
                      progressColor: Colors.green,
                      backgroundColor: Colors.red,
                      center: Text("${(percent * 100).floor()} %"),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: LinearPercentIndicator(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      percent: percent,
                      leading: Text("$daysDone Days"),
                      center: Text("${(percent * 100).floor()} %"),
                      trailing: Text("$daysLeft Days"),
                      progressColor: Colors.green,
                      backgroundColor: Colors.red,
                      lineHeight: 25,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text("$allDays Days"),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class _ViewModel {
  final TimeProgress timeProgress;

  _ViewModel({
    @required this.timeProgress,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      timeProgress: store.state.timeProgressList[0],
    );
  }
}
