import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/screens/home_screen.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';
import 'package:time_progress_tracker/widgets/detail_screen_floating_action_buttons.dart';
import 'package:time_progress_tracker/widgets/progress_editor_widget.dart';
import 'package:time_progress_tracker/widgets/progress_view_widget.dart';
import 'package:time_progress_tracker/widgets/store_connectors/time_progress_store_connector.dart';

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

  @override
  Widget build(BuildContext context) {
    final ProgressDetailScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(ProgressDetailScreen.title),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: StoreConnector(
          onInit: loadTimeProgressListIfUnloaded,
          converter: (store) => timeProgressByIdSelector(store.state, args.id),
          builder: (BuildContext context, TimeProgress timeProgress) {
            if (timeProgress == null) //+++++Time Progress Not Found Error+++++
              return Center(
                child: Text("Error Invalid Time Progress"),
              );
            if (_editedProgress == null) {
              _editedProgress = timeProgress;
              _originalProgress = timeProgress;
            } // initialize _editedProgress

            List<Widget> columnChildren = [
              Expanded(
                child: StoreConnector<AppState, AppSettings>(
                  onInit: loadSettingsIfUnloaded,
                  converter: (store) => appSettingsSelector(store.state),
                  builder: (BuildContext context, AppSettings settings) {
                    return ProgressViewWidget(
                      timeProgress: _editMode ? _editedProgress : timeProgress,
                      doneColor: settings.doneColor,
                      leftColor: settings.leftColor,
                    );
                  },
                ),
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
                context, ModalRoute.withName(HomeScreen.routeName));
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
