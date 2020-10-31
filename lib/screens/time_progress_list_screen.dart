import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_calculator/actions/actions.dart';
import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/models/time_progress.dart';
import 'package:time_progress_calculator/screens/progress_creation_screen.dart';
import 'package:time_progress_calculator/widgets/app_drawer_widget.dart';

class TimeProgressListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Progress List"),
      ),
      drawer: AppDrawer(),
      body: StoreConnector(
        converter: _ViewModel.fromStore,
        onInit: (store) {
          store.dispatch(LoadTimeProgressListAction());
        },
        builder: (context, _ViewModel vm) {
          return ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: vm.timeProgressList.length,
            itemBuilder: (context, index) {
              return Text(vm.timeProgressList[index].toString());
            },
          );
        },
      ),
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
  final int timeProgressCount;

  _ViewModel({
    @required this.timeProgressList,
    @required this.timeProgressCount,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      timeProgressList: store.state.timeProgressList,
      timeProgressCount: store.state.timeProgressList.length,
    );
  }
}
