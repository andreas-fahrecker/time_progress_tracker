import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_calculator/actions/actions.dart';
import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/models/time_progress.dart';
import 'package:time_progress_calculator/selectors/time_progress_selectors.dart';
import 'package:time_progress_calculator/widgets/app_drawer_widget.dart';
import 'package:time_progress_calculator/widgets/progress_detail_circular_percent_widget.dart';
import 'package:time_progress_calculator/widgets/progress_detail_fab_editing_row_widget.dart';
import 'package:time_progress_calculator/widgets/progress_detail_linear_percent_widget.dart';

class ProgressDetailScreenArguments {
  final String id;

  ProgressDetailScreenArguments(this.id);
}

class ProgressDetailScreen extends StatefulWidget {
  static const routeName = "/progress-detail";

  @override
  State<StatefulWidget> createState() {
    return _ProgressDetailScreenState();
  }
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool isBeingEdited = false;
  TimeProgress editedProgress = TimeProgress(
      "Default Name", DateTime.now(), DateTime(DateTime.now().year + 1));

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      this.setState(() {
        this.editedProgress =
            this.editedProgress.copyWith(name: _nameController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDetailScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    Widget titleTextEditing = TextField(
      controller: this._nameController,
      decoration: InputDecoration(
          border: OutlineInputBorder(), labelText: "Progress Name"),
    );

    Widget editDatesRow = Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: FlatButton(
            color: Colors.blue,
            child: Text(
                "Start Date: ${this.editedProgress.startTime.toLocal().toString().split(" ")[0]}"),
            onPressed: () async {
              DateTime picked = await showDatePicker(
                context: context,
                initialDate: this.editedProgress.startTime,
                firstDate: DateTime(this.editedProgress.startTime.year - 1),
                lastDate: DateTime(this.editedProgress.startTime.year + 1),
              );
              if (picked != null) {
                this.setState(() {
                  this.editedProgress =
                      this.editedProgress.copyWith(startTime: picked);
                });
              }
            },
          ),
        ),
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 5,
          child: FlatButton(
            color: Colors.blue,
            child: Text(
                "End Date: ${this.editedProgress.endTime.toLocal().toString().split(" ")[0]}"),
            onPressed: () async {
              DateTime picked = await showDatePicker(
                context: context,
                initialDate: this.editedProgress.endTime,
                firstDate: DateTime(this.editedProgress.endTime.year - 1),
                lastDate: DateTime(this.editedProgress.endTime.year + 1),
              );
              if (picked != null) {
                this.setState(() {
                  this.editedProgress =
                      this.editedProgress.copyWith(endTime: picked);
                });
              }
            },
          ),
        )
      ],
    );

    Widget floatingActionButtonsNotEditing = Row(
      children: <Widget>[
        Expanded(
          child: FloatingActionButton(
            heroTag: "editTimeProgressBTN",
            child: Icon(Icons.edit),
            onPressed: () {
              this.setState(() {
                this.isBeingEdited = true;
                this.editedProgress = timeProgressByIdSelector(
                    StoreProvider.of<AppState>(context).state, args.id);
                this._nameController.text = this.editedProgress.name;
              });
            },
          ),
        ),
        Expanded(
          child: FloatingActionButton(
            heroTag: "deleteTimeProgressBTN",
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            onPressed: () {
              StoreProvider.of<AppState>(context)
                  .dispatch(DeleteTimeProgressAction(args.id));
              Navigator.pushNamed(context, "/");
            },
          ),
        )
      ],
    );

    Widget floatingActionButtonsEditing = ProgressDetailFabEditingRow(
      onSave: () {
        StoreProvider.of<AppState>(context)
            .dispatch(UpdateTimeProgressAction(args.id, this.editedProgress));
        this.setState(() {
          this.isBeingEdited = false;
        });
      },
      onCancelEdit: () {
        this.setState(() {
          this.isBeingEdited = false;
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Progress"),
      ),
      drawer: AppDrawer(),
      body: Container(
        margin: EdgeInsets.all(8),
        child: StoreConnector(
          converter: (Store<AppState> store) =>
              _ViewModel.fromStoreAndArg(store, args),
          onInit: (Store<AppState> store) {
            if (!store.state.hasLoaded)
              store.dispatch(LoadTimeProgressListAction());
          },
          builder: (BuildContext context, _ViewModel vm) {
            Widget titleTextNotEditing = FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                vm.timeProgress.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            );

            return Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: this.isBeingEdited
                      ? titleTextEditing
                      : titleTextNotEditing,
                ),
                Expanded(
                  flex: 2,
                  child: ProgressDetailCircularPercent(
                    percentDone: this.isBeingEdited
                        ? this.editedProgress.percentDone()
                        : vm.timeProgress.percentDone(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ProgressDetailLinearPercent(
                    timeProgress: this.isBeingEdited
                        ? this.editedProgress
                        : vm.timeProgress,
                  ),
                ),
                this.isBeingEdited
                    ? Expanded(
                        flex: 1,
                        child: editDatesRow,
                      )
                    : Spacer(flex: 1),
                Spacer(
                  flex: 1,
                )
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: this.isBeingEdited
          ? floatingActionButtonsEditing
          : floatingActionButtonsNotEditing,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

class _ViewModel {
  final TimeProgress timeProgress;

  _ViewModel({@required this.timeProgress});

  static _ViewModel fromStoreAndArg(
      Store<AppState> store, ProgressDetailScreenArguments args) {
    return _ViewModel(
      timeProgress: timeProgressByIdSelector(store.state, args.id),
    );
  }
}
