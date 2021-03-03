import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';
import 'package:time_progress_tracker/widgets/progress_editor_widget.dart';

class ProgressCreationScreen extends StatefulWidget {
  static const routeName = "/create-progress";
  static const title = "Create Time Progress";

  @override
  State<StatefulWidget> createState() {
    return _ProgressCreationScreenState();
  }
}

class _ProgressCreationScreenState extends State<ProgressCreationScreen> {
  TimeProgress timeProgressToCreate;
  bool _isProgressValid = false;

  void initTimeProgress(TimeProgress timeProgress) {
    if (timeProgressToCreate == null)
      setState(() {
        timeProgressToCreate = timeProgress;
      });
  }

  void onTimeProgressChanged(
      TimeProgress newTimeProgress, bool isNewProgressValid) {
    setState(() {
      timeProgressToCreate = newTimeProgress;
      _isProgressValid = isNewProgressValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProgressCreationScreen.title),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: StoreConnector<AppState, _ViewModel>(
            onInit: loadSettingsIfUnloaded,
            converter: (store) => _ViewModel.create(store),
            builder: (context, _ViewModel viewModel) {
              initTimeProgress(viewModel.defaultDurationProgress);
              return ProgressEditorWidget(
                timeProgress: timeProgressToCreate,
                onTimeProgressChanged: onTimeProgressChanged,
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: <Widget>[
          Expanded(
            child: StoreConnector<AppState, _ViewModel>(
              onInit: loadSettingsIfUnloaded,
              converter: (store) => _ViewModel.create(store),
              builder: (context, _ViewModel vm) => FloatingActionButton(
                heroTag: "createTimeProgressBTN",
                child: Icon(Icons.save),
                onPressed: _isProgressValid
                    ? () {
                        vm.onAddTimeProgress(timeProgressToCreate);
                        Navigator.pop(context);
                      }
                    : null,
              ),
            ),
          ),
          Expanded(
            child: FloatingActionButton(
              heroTag: "cancelTimeProgressCreationBTN",
              child: Icon(Icons.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ViewModel {
  final TimeProgress defaultDurationProgress;
  final void Function(TimeProgress) onAddTimeProgress;

  _ViewModel({
    @required this.defaultDurationProgress,
    @required this.onAddTimeProgress,
  });

  factory _ViewModel.create(Store<AppState> store) {
    AppSettings settings = appSettingsSelector(store.state);

    _onAddTimeProgress(TimeProgress tp) {
      if (TimeProgress.isValid(tp)) store.dispatch(AddTimeProgressAction(tp));
    }

    return _ViewModel(
      defaultDurationProgress:
          TimeProgress.defaultFromDuration(settings.duration),
      onAddTimeProgress: _onAddTimeProgress,
    );
  }
}
