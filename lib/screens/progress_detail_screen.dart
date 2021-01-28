import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_exceptions.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/screens/progress_dashboard_screen.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';
import 'package:time_progress_tracker/widgets/app_drawer_widget.dart';
import 'package:time_progress_tracker/widgets/app_yes_no_dialog_widget.dart';
import 'package:time_progress_tracker/widgets/progress_detail_widgets/progress_detail_circular_percent_widget.dart';
import 'package:time_progress_tracker/widgets/progress_detail_widgets/progress_detail_edit_dates_row_widget.dart';
import 'package:time_progress_tracker/widgets/progress_detail_widgets/progress_detail_fab_editing_row_widget.dart';
import 'package:time_progress_tracker/widgets/progress_detail_widgets/progress_detail_fab_row_widget.dart';
import 'package:time_progress_tracker/widgets/progress_detail_widgets/progress_detail_linear_percent_widget.dart';

class ProgressDetailScreenArguments {
  final String id;

  ProgressDetailScreenArguments(this.id);
}

class ProgressDetailScreen extends StatefulWidget {
  static const routeName = "/progress-detail";

  final String appVersion;

  ProgressDetailScreen({
    Key key,
    @required this.appVersion,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProgressDetailScreenState();
  }
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  bool _isBeingEdited = false;
  final TextEditingController _nameController = TextEditingController();

  TimeProgress _editedProgress = TimeProgress.initialDefault();

  bool _validName = true;

  void _onStartDateChanged(DateTime picked) {
    if (picked != null) {
      setState(() {
        _editedProgress = _editedProgress.copyWith(startTime: picked);
      });
    }
  }

  void _onEndDateChanged(DateTime picked) {
    if (picked != null) {
      setState(() {
        _editedProgress = _editedProgress.copyWith(endTime: picked);
      });
    }
  }

  void _onSaveTimeProgress(Store<AppState> store, id) {
    store.dispatch(UpdateTimeProgressAction(id, _editedProgress));
    setState(() {
      _isBeingEdited = false;
    });
  }

  void _showCancelEditTimeProgressDialog(AppState state, id) {
    TimeProgress originalTp = timeProgressByIdSelector(state, id);
    if (originalTp != _editedProgress) {
      String originalName = timeProgressByIdSelector(state, id).name;
      showDialog(
        context: context,
        builder: (_) => AppYesNoDialog(
          titleText: "Cancel Editing of $originalName",
          contentText:
              "Are you sure that you want to discard the changes done to $originalName",
          onYesPressed: _onCancelEditTimeProgress,
          onNoPressed: _onCloseDialog,
        ),
      );
    } else {
      setState(() {
        _isBeingEdited = false;
      });
    }
  }

  void _onCancelEditTimeProgress() {
    setState(() {
      _isBeingEdited = false;
    });
    Navigator.pop(context);
  }

  void _onEditTimeProgress(Store<AppState> store, id) {
    setState(() {
      _isBeingEdited = true;
      _editedProgress = timeProgressByIdSelector(store.state, id);
      _nameController.text = _editedProgress.name;
    });
  }

  void _showDeleteTimeProgressDialog(Store<AppState> store, id) {
    showDialog(
      context: context,
      builder: (_) => AppYesNoDialog(
        titleText: "Delete ${timeProgressByIdSelector(store.state, id).name}",
        contentText: "Are you sure you want to delete this time progress?",
        onYesPressed: () => _onDeleteTimeProgress(store, id),
        onNoPressed: _onCloseDialog,
      ),
    );
  }

  void _onDeleteTimeProgress(Store<AppState> store, String id) {
    store.dispatch(DeleteTimeProgressAction(id));
    Navigator.popAndPushNamed(context, ProgressDashboardScreen.routeName);
  }

  void _onCloseDialog() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      try {
        TimeProgress editedProgress =
            _editedProgress.copyWith(name: _nameController.text);
        setState(() {
          _editedProgress = editedProgress;
          _validName = true;
        });
      } on TimeProgressInvalidNameException catch (e) {
        setState(() {
          _validName = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDetailScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    final Store<AppState> store = StoreProvider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Progress"),
      ),
      drawer: AppDrawer(
        appVersion: widget.appVersion,
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: StoreConnector(
          converter: (Store<AppState> store) =>
              _ViewModel.fromStoreAndArg(store, args),
          onInit: loadTimeProgressListIfUnloaded,
          builder: (BuildContext context, _ViewModel vm) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: _isBeingEdited
                      ? TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Progress Name",
                            errorText: _validName
                                ? null
                                : "The Name of the Time Progress has to be set.",
                          ),
                        )
                      : (vm.hasProgressStarted && !vm.hasEnded)
                          ? FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                vm.timeProgress.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            )
                          : Center(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  vm.timeProgress.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                ),
                (vm.hasProgressStarted && !vm.hasEnded)
                    ? Expanded(
                        flex: 2,
                        child: ProgressDetailCircularPercent(
                          percentDone: _isBeingEdited
                              ? _editedProgress.percentDone()
                              : vm.timeProgress.percentDone(),
                        ),
                      )
                    : Expanded(
                        flex: 2,
                        child: !vm.hasEnded
                            ? Text(
                                "Starts in ${vm.timeProgress.startTime.difference(DateTime.now()).inDays} Days.")
                            : Text(
                                "Ended ${DateTime.now().difference(vm.timeProgress.endTime).inDays} Days ago."),
                      ),
                (vm.hasProgressStarted && !vm.hasEnded)
                    ? Expanded(
                        flex: 1,
                        child: ProgressDetailLinearPercent(
                          timeProgress: _isBeingEdited
                              ? _editedProgress
                              : vm.timeProgress,
                        ),
                      )
                    : Spacer(
                        flex: 1,
                      ),
                Expanded(
                  flex: 1,
                  child: Text(
                      "${_isBeingEdited ? _editedProgress.allDays() : vm.timeProgress.allDays()} Days"),
                ),
                this._isBeingEdited
                    ? Expanded(
                        flex: 1,
                        child: ProgressDetailEditDatesRow(
                          startTime: _editedProgress.startTime,
                          endTime: _editedProgress.endTime,
                          onStartTimeChanged: _onStartDateChanged,
                          onEndTimeChanged: _onEndDateChanged,
                        ),
                      )
                    : Spacer(flex: 1),
                Spacer(flex: 1)
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isBeingEdited
          ? ProgressDetailFabEditingRow(
              onSave: () =>
                  _validName ? _onSaveTimeProgress(store, args.id) : null,
              onCancelEdit: () =>
                  _showCancelEditTimeProgressDialog(store.state, args.id),
            )
          : ProgressDetailFabRow(
              onEdit: () => _onEditTimeProgress(store, args.id),
              onDelete: () => _showDeleteTimeProgressDialog(store, args.id),
            ),
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
  final bool hasProgressStarted;
  final bool hasEnded;

  _ViewModel({
    @required this.timeProgress,
    @required this.hasProgressStarted,
    @required this.hasEnded,
  });

  static _ViewModel fromStoreAndArg(
      Store<AppState> store, ProgressDetailScreenArguments args) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    TimeProgress tp = timeProgressByIdSelector(store.state, args.id);
    return _ViewModel(
        timeProgress: tp,
        hasProgressStarted: currentTime > tp.startTime.millisecondsSinceEpoch,
        hasEnded: tp.endTime.millisecondsSinceEpoch < currentTime);
  }
}
