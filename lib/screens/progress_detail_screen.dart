import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/screens/home_screen.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';
import 'package:time_progress_tracker/widgets/detail_screen_floating_action_buttons.dart';
import 'package:time_progress_tracker/widgets/progress_editor_widget.dart';
import 'package:time_progress_tracker/widgets/progress_view_widget.dart';

class ProgressDetailScreenArguments {
  final String id;

  ProgressDetailScreenArguments(this.id);
}

class ProgressDetailScreen extends StatefulWidget {
  static const routeName = "/progress-detail";
  static const title = "Progress View";

  @override
  State<StatefulWidget> createState() {
    return _ProgressDetailScreenState();
  }
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  bool _editMode = false;
  TimeProgress _editedProgress;

  void _onEditedProgressChanged(TimeProgress newProgress) {
    setState(() {
      _editedProgress = newProgress;
    });
  }

  void _switchEditMode(bool newMode) {
    setState(() {
      _editMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDetailScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final TimeProgress _timeProgress =
        timeProgressByIdSelector(store.state, args.id);

    if (_timeProgress == null) //+++++Time Progress Not Found Error+++++
      return Center(
        child: Text("Error Invalid Time Progress"),
      );
    if (_editedProgress == null)
      _editedProgress = _timeProgress; // initialize _editedProgress

    void _saveEditedProgress() {
      store.dispatch(UpdateTimeProgressAction(args.id, _editedProgress));
      _switchEditMode(false);
    }

    void _deleteTimeProgress() {
      store.dispatch(DeleteTimeProgressAction(args.id));
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
    }

    List<Widget> columnChildren = [
      Expanded(
        child: ProgressViewWidget(
            timeProgress: _editMode ? _editedProgress : _timeProgress),
      )
    ];
    if (_editMode)
      columnChildren.add(Expanded(
        child: ProgressEditorWidget(
          timeProgress: _editedProgress,
          onTimeProgressChanged: _onEditedProgressChanged,
        ),
      ));

    return Scaffold(
      appBar: AppBar(
        title: Text(ProgressDetailScreen.title),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: columnChildren,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: DetailScreenFloatingActionButtons(
          editMode: _editMode,
          originalProgress: timeProgressByIdSelector(store.state, args.id),
          editedProgress: _editedProgress,
          onEditProgress: () => _switchEditMode(true),
          onSaveEditedProgress: _saveEditedProgress,
          onCancelEditProgress: () => _switchEditMode(false),
          onDeleteProgress: _deleteTimeProgress),
    );
  }
}
