import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/app.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';
import 'package:time_progress_tracker/widgets/home/tabs/settings/color_settings_widget.dart';
import 'package:time_progress_tracker/widgets/home/tabs/settings/duration_settings_widget.dart';

class HomeSettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: loadSettingsIfUnloaded,
      converter: (store) => _ViewModel.create(store),
      builder: (context, _ViewModel vm) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: ColorSettingsWidget(
                    doneColor: vm.doneColor,
                    leftColor: vm.leftColor,
                    updateDoneColor: vm.onDoneColorChanged,
                    updateLeftColor: vm.onLeftColorChanged,
                  ),
                ),
                Expanded(
                  child: DurationSettingsWidget(
                    duration: vm.duration,
                    updateDuration: vm.onDurationChanged,
                  ),
                ),
                Spacer(),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      showAboutDialog(
                          context: context,
                          applicationName: TimeProgressTrackerApp.name,
                          applicationVersion: "Beta",
                          applicationLegalese:
                              '\u00a9Andreas Fahrecker 2020-2021');
                    },
                    child: Text("About"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final Color doneColor, leftColor;
  final void Function(Color) onDoneColorChanged, onLeftColorChanged;
  final Duration duration;
  final void Function(Duration) onDurationChanged;

  _ViewModel({
    @required this.doneColor,
    @required this.leftColor,
    @required this.onDoneColorChanged,
    @required this.onLeftColorChanged,
    @required this.duration,
    @required this.onDurationChanged,
  });

  factory _ViewModel.create(Store<AppState> store) {
    AppSettings settings = appSettingsSelector(store.state);

    void _onDoneColorChanged(Color c) => store
        .dispatch(UpdateAppSettingsActions(settings.copyWith(doneColor: c)));
    void _onLeftColorChanged(Color c) => store
        .dispatch(UpdateAppSettingsActions(settings.copyWith(leftColor: c)));

    void _onDurationChanged(Duration d) => store
        .dispatch(UpdateAppSettingsActions(settings.copyWith(duration: d)));

    return _ViewModel(
        doneColor: settings.doneColor,
        leftColor: settings.leftColor,
        onDoneColorChanged: _onDoneColorChanged,
        onLeftColorChanged: _onLeftColorChanged,
        duration: settings.duration,
        onDurationChanged: _onDurationChanged);
  }
}
