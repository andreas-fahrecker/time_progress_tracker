import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/screens/home_screen.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';
import 'package:time_progress_tracker/widgets/app_yes_no_dialog_widget.dart';
import 'package:time_progress_tracker/widgets/progress_detail_widgets/progress_detail_fab_editing_row_widget.dart';
import 'package:time_progress_tracker/widgets/progress_detail_widgets/progress_detail_fab_row_widget.dart';
import 'package:time_progress_tracker/widgets/progress_editor_widget.dart';
import 'package:time_progress_tracker/widgets/progress_view_widget.dart';

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
  bool _editMode = false;
  TimeProgress _editedProgress = TimeProgress.initialDefault();

  void _onEditedProgressChanged(TimeProgress newProgress) {
    setState(() {
      _editedProgress = newProgress;
    });
  }

  void _onSaveTimeProgress(Store<AppState> store, id) {
    if (!TimeProgress.isValid(_editedProgress)) return;
    store.dispatch(UpdateTimeProgressAction(id, _editedProgress));
    setState(() {
      _editMode = false;
    });
  }

  void _showCancelEditTimeProgressDialog(AppState state, id) {
    TimeProgress originalTp = timeProgressByIdSelector(state, id);
    if (originalTp != _editedProgress) {
      String originalName = originalTp.name;
      showDialog(
        context: context,
        builder: (_) => AppYesNoDialog(
          titleText: "Cancel Editing of $originalName",
          contentText:
              "Are you sure that you want to discard the changes done to $originalName",
          onYesPressed: () {
            _cancelEditMode();
            Navigator.pop(context);
          },
          onNoPressed: _onCloseDialog,
        ),
      );
    } else {
      _cancelEditMode();
    }
  }

  void _cancelEditMode() {
    setState(() {
      _editMode = false;
    });
  }

  void _onEditTimeProgress(AppState state, id) {
    setState(() {
      _editMode = true;
      _editedProgress = timeProgressByIdSelector(state, id);
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
    Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
  }

  void _onCloseDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDetailScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final ThemeData appTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Progress"),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: StoreConnector(
          converter: (Store<AppState> store) =>
              _ViewModel.fromStoreAndArg(store, args),
          onInit: loadTimeProgressListIfUnloaded,
          builder: (BuildContext context, _ViewModel vm) {
            if (vm.timeProgress == null)
              return Center(
                child: Text("Error Invalid Time Progress"),
              );
            List<Widget> columnChildren = [
              Expanded(
                child: ProgressViewWidget(
                    timeProgress:
                        _editMode ? _editedProgress : vm.timeProgress),
              )
            ];
            if (_editMode)
              columnChildren.add(Expanded(
                child: ProgressEditorWidget(
                  timeProgress: _editedProgress,
                  onTimeProgressChanged: _onEditedProgressChanged,
                ),
              ));
            return Column(
              children: columnChildren,
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: [
          Expanded(
            child: FloatingActionButton(
              heroTag: _editMode
                  ? "saveEditedTimeProgressBTN"
                  : "editTimeProgressBTN",
              child: _editMode ? Icon(Icons.save) : Icon(Icons.edit),
              backgroundColor: _editMode ? Colors.green : appTheme.accentColor,
              onPressed: _editMode
                  ? () {
                      _onSaveTimeProgress(store, args.id);
                    }
                  : () {
                      _onEditTimeProgress(store.state, args.id);
                    },
            ),
          ),
          Expanded(
            child: FloatingActionButton(
              heroTag: _editMode
                  ? "cancelEditTimeProgressBTN"
                  : "deleteTimeProgressBTN",
              child: _editMode ? Icon(Icons.cancel) : Icon(Icons.delete),
              backgroundColor: Colors.red,
              onPressed: _editMode
                  ? () {
                      _showCancelEditTimeProgressDialog(store.state, args.id);
                    }
                  : () {
                      _showDeleteTimeProgressDialog(store, args.id);
                    },
            ),
          ),
        ],
      ),
    );
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
