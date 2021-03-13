import 'package:flutter/material.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/redux/store_connectors/settings_store_connector.dart';
import 'package:time_progress_tracker/redux/store_connectors/time_progress_store_connector.dart';
import 'package:time_progress_tracker/ui/screens/dashboard_screen.dart';
import 'package:time_progress_tracker/ui/detail_screen_floating_action_buttons.dart';
import 'package:time_progress_tracker/ui/progress/progress_editor_widget.dart';
import 'package:time_progress_tracker/ui/progress/progress_view_widget.dart';

class ProgressDetailScreenArguments {
  final String id;

  ProgressDetailScreenArguments(this.id);
}

class ProgressDetailScreen extends StatefulWidget {
  static const routeName = "/progress";
  static const title = "Progress View";

  @override
  State<StatefulWidget> createState() {
    return _ProgressDetailScreenState();
  }
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  bool _editMode = false, _isEditedProgressValid = false;
  TimeProgress _editedProgress, _originalProgress;

  void _initEditedProgress(TimeProgress tp) {
    if (_editedProgress == null) {
      _editedProgress = tp;
      _originalProgress = tp;
    }
  }

  void _onEditedProgressChanged(
      TimeProgress newProgress, bool isNewProgressValid) {
    setState(() {
      _editedProgress = newProgress;
      _isEditedProgressValid = isNewProgressValid;
    });
  }

  void _switchEditMode(bool newMode) {
    setState(() {
      _editMode = newMode;
    });
  }

  void _cancelEditMode() {
    setState(() {
      _editMode = false;
      _editedProgress = _originalProgress;
    });
  }

  List<Widget> _renderColumnChildren(
      SettingsViewModel settingsVm, TimeProgressViewModel tpVm) {
    List<Widget> columnChildren = [
      Expanded(
          child: ProgressViewWidget(
        timeProgress: _editMode ? _editedProgress : tpVm.tp,
        doneColor: settingsVm.appSettings.doneColor,
        leftColor: settingsVm.appSettings.leftColor,
      ))
    ];
    if (_editMode)
      columnChildren.add(Expanded(
          child: ProgressEditorWidget(
        timeProgress: _editedProgress,
        onTimeProgressChanged: _onEditedProgressChanged,
      )));
    return columnChildren;
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDetailScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(ProgressDetailScreen.title),
      ),
      body: SettingsStoreConnector(
        loadedBuilder: (context, settingsVm) {
          return TimeProgressStoreConnector(
            timeProgressId: args.id,
            loadedBuilder: (context, tpVm) {
              _initEditedProgress(tpVm.tp);
              return Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: _renderColumnChildren(settingsVm, tpVm),
                  ));
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TimeProgressStoreConnector(
        timeProgressId: args.id,
        loadedBuilder: (context, tpVm) {
          void _saveEditedProgress() {
            tpVm.updateTimeProgress(_editedProgress);
            _switchEditMode(false);
          }

          void _deleteTimeProgress() {
            tpVm.deleteTimeProgress();
            Navigator.popUntil(
                context, ModalRoute.withName(DashboardScreen.routeName));
          }

          return DetailScreenFloatingActionButtons(
              editMode: _editMode,
              originalProgress: tpVm.tp,
              editedProgress: _editedProgress,
              isEditedProgressValid: _isEditedProgressValid,
              onEditProgress: () => _switchEditMode(true),
              onSaveEditedProgress: _saveEditedProgress,
              onCancelEditProgress: _cancelEditMode,
              onDeleteProgress: _deleteTimeProgress);
        },
      ),
    );
  }
}
