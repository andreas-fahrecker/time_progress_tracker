import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/redux/store_connectors/settings_store_connector.dart';
import 'package:time_progress_tracker/redux/store_connectors/time_progress_store_connector.dart';
import 'package:time_progress_tracker/ui/buttons/detail_screen_leading_button.dart';
import 'package:time_progress_tracker/ui/buttons/detail_screen_trailing_button.dart';
import 'package:time_progress_tracker/ui/progress/progress_editor_widget.dart';
import 'package:time_progress_tracker/ui/progress/progress_view_widget.dart';
import 'package:time_progress_tracker/utils/theme_utils.dart';

class ProgressDetailScreen extends StatefulWidget {
  static const title = "Progress View";

  final String tpId;

  const ProgressDetailScreen({Key? key, required this.tpId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProgressDetailScreenState();
  }
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  bool _editMode = false, _isEditedProgressValid = false;
  TimeProgress _editedProgress = TimeProgress.initialDefault(),
      _originalProgress = TimeProgress.initialDefault();

  void _initEditedProgress(TimeProgress tp) {
    if (_editedProgress == TimeProgress.initialDefault()) {
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
    TimeProgress tp = tpVm.tp ?? TimeProgress.initialDefault();
    List<Widget> columnChildren = [
      Expanded(
          child: ProgressViewWidget(
        timeProgress: _editMode ? _editedProgress : tp,
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
    TimeProgressStoreConnector leadingActionButton = TimeProgressStoreConnector(
      timeProgressId: widget.tpId,
      loadedBuilder: (context, tpVm) {
        void _saveEditedTp() {
          tpVm.updateTimeProgress(_editedProgress);
          _switchEditMode(false);
        }

        return DetailScreenLeadingButton(
          isEditMode: _editMode,
          isEditedTpValid: _isEditedProgressValid,
          saveTp: _saveEditedTp,
          editTp: () => _switchEditMode(true),
        );
      },
    );

    TimeProgressStoreConnector trailingActionButton =
        TimeProgressStoreConnector(
      timeProgressId: widget.tpId,
      loadedBuilder: (context, tpVm) {
        void _deleteTp() {
          tpVm.deleteTimeProgress();
          Navigator.popUntil(context, (route) => route.isFirst);
        }

        return DetailScreenTrailingButton(
          isEditMode: _editMode,
          cancelEditTp: _cancelEditMode,
          deleteTp: _deleteTp,
        );
      },
    );

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(
          ProgressDetailScreen.title,
          style: toolbarTextStyle,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          transitionBetweenRoutes: false,
          leading: leadingActionButton,
          trailing: trailingActionButton,
        ),
      ),
      material: (_, __) => MaterialScaffoldData(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          children: [
            Expanded(child: leadingActionButton),
            Expanded(child: trailingActionButton),
          ],
        ),
      ),
      body: SettingsStoreConnector(
        loadedBuilder: (context, settingsVm) {
          return TimeProgressStoreConnector(
            timeProgressId: widget.tpId,
            loadedBuilder: (context, tpVm) {
              _initEditedProgress(tpVm.tp!);
              return Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: _renderColumnChildren(settingsVm, tpVm),
                  ));
            },
          );
        },
      ),
    );
  }
}
