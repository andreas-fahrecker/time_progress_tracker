import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/redux/actions/time_progress_actions.dart';
import 'package:time_progress_tracker/redux/app_state.dart';
import 'package:time_progress_tracker/redux/redux_selectors.dart';
import 'package:time_progress_tracker/redux/store_connectors/create_time_progress_store_connector.dart';
import 'package:time_progress_tracker/ui/buttons/create_progress_button.dart';
import 'package:time_progress_tracker/ui/buttons/platform_action_button.dart';
import 'package:time_progress_tracker/ui/progress/progress_editor_widget.dart';
import 'package:time_progress_tracker/utils/theme_utils.dart';
import 'package:time_progress_tracker/utils/helper_functions.dart';

class ProgressCreationScreen extends StatefulWidget {
  static const routeName = "/create-progress";
  static const title = "Create Time Progress";

  @override
  State<StatefulWidget> createState() {
    return _ProgressCreationScreenState();
  }
}

class _ProgressCreationScreenState extends State<ProgressCreationScreen> {
  TimeProgress timeProgressToCreate = TimeProgress.initialDefault();
  bool _isProgressValid = false;

  void initTimeProgress(TimeProgress timeProgress) {
    if (timeProgressToCreate == TimeProgress.initialDefault())
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
    void _onCreateTimeProgress(CreateTimeProgressViewModel vm) {
      if (!_isProgressValid) return null;
      vm.addTimeProgress(timeProgressToCreate);
      Navigator.pop(context);
    }

    initTimeProgress(TimeProgress.defaultFromDuration(
        StoreProvider.of<AppState>(context).state.appSettings.duration));

    Widget _createActionButton = CreateTimeProgressStoreConnector(
      loadedBuilder: (context, CreateTimeProgressViewModel vm) =>
          PlatformActionButton(
              heroTag: "createTimeProgressBTN",
              icon: Icons.save,
              onBtnPressed: () => _onCreateTimeProgress(vm)),
    );

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(
          ProgressCreationScreen.title,
          style: toolbarTextStyle,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          transitionBetweenRoutes: false,
          trailing: _createActionButton,
        ),
      ),
      material: (_, __) => MaterialScaffoldData(
        floatingActionButton: Row(
          children: [
            Expanded(
              child: _createActionButton,
            )
          ],
        ),
      ),
      body: ProgressEditorWidget(
        timeProgress: timeProgressToCreate,
        onTimeProgressChanged: onTimeProgressChanged,
      ),
    );

    return CreateTimeProgressStoreConnector(
      loadedBuilder: (context, CreateTimeProgressViewModel vm) {
        initTimeProgress(vm.defaultProgress);
        return PlatformScaffold(
          appBar: PlatformAppBar(
            title: Text(
              ProgressCreationScreen.title,
              style: toolbarTextStyle,
            ),
            cupertino: (_, __) => CupertinoNavigationBarData(
              transitionBetweenRoutes: false,
              trailing: CreateProgressButton(
                createProgress: () => _onCreateTimeProgress(vm),
              ),
            ),
          ),
          material: (_, __) => MaterialScaffoldData(
            floatingActionButton: Row(
              children: [
                Expanded(
                  child: CreateProgressButton(
                    createProgress: () => _onCreateTimeProgress(vm),
                  ),
                )
              ],
            ),
          ),
          body: ProgressEditorWidget(
            timeProgress: timeProgressToCreate,
            onTimeProgressChanged: onTimeProgressChanged,
          ),
        );
      },
    );

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
    required this.defaultDurationProgress,
    required this.onAddTimeProgress,
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