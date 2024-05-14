import 'package:flutter/material.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/screens/home_screen.dart';
import 'package:time_progress_tracker/widgets/detail_screen_floating_action_buttons.dart';
import 'package:time_progress_tracker/widgets/progress_editor_widget.dart';
import 'package:time_progress_tracker/widgets/progress_view_widget.dart';
import 'package:time_progress_tracker/widgets/store_connectors/settings_store_connector.dart';
import 'package:time_progress_tracker/widgets/store_connectors/time_progress_store_connector.dart';

class ProgressDetailScreenArguments {
  final String id;

  ProgressDetailScreenArguments(this.id);
}

class ProgressDetailScreen extends StatefulWidget {
  static const routeName = "/progress";
  static const title = "Progress View";

  const ProgressDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProgressDetailScreenState();
  }
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  bool _editMode = false, _isEditedProgressValid = false;
  TimeProgress? _editedProgress, _originalProgress;

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
    List<Widget> columnChildren = [];
    if (!_editMode) {
      columnChildren.add(Expanded(
          child: ProgressViewWidget(
        timeProgress: _editMode ? _editedProgress ?? tpVm.tp : tpVm.tp,
        doneColor: settingsVm.appSettings.doneColor,
        leftColor: settingsVm.appSettings.leftColor,
      )));
    } else {
      columnChildren.add(Expanded(
          child: ProgressEditorWidget(
        timeProgress: _editedProgress ?? tpVm.tp,
        onTimeProgressChanged: _onEditedProgressChanged,
      )));
    }
    return columnChildren;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData appTheme = Theme.of(context);
    final ProgressDetailScreenArguments args = ModalRoute.of(context)
        ?.settings
        .arguments as ProgressDetailScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text(ProgressDetailScreen.title),
        backgroundColor: appTheme.colorScheme.primary,
      ),
      body: SettingsStoreConnector(
        loadedBuilder: (context, settingsVm) {
          return TimeProgressStoreConnector(
            timeProgressId: args.id,
            loadedBuilder: (context, tpVm) {
              _initEditedProgress(tpVm.tp);
              return Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: _renderColumnChildren(settingsVm, tpVm),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TimeProgressStoreConnector(
        timeProgressId: args.id,
        loadedBuilder: (context, tpVm) {
          void saveEditedProgress() {
            tpVm.updateTimeProgress(_editedProgress ?? tpVm.tp);
            _switchEditMode(false);
          }

          void deleteTimeProgress() {
            tpVm.deleteTimeProgress();
            Navigator.popUntil(
                context, ModalRoute.withName(HomeScreen.routeName));
          }

          return DetailScreenFloatingActionButtons(
              editMode: _editMode,
              originalProgress: tpVm.tp,
              editedProgress: _editedProgress ?? tpVm.tp,
              isEditedProgressValid: _isEditedProgressValid,
              onEditProgress: () => _switchEditMode(true),
              onSaveEditedProgress: saveEditedProgress,
              onCancelEditProgress: _cancelEditMode,
              onDeleteProgress: deleteTimeProgress);
        },
      ),
    );
  }
}
