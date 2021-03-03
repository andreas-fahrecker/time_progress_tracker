import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/app.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';
import 'package:time_progress_tracker/widgets/home/tabs/settings/color_settings_widget.dart';

class HomeSettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppSettings>(
      onInit: loadSettingsIfUnloaded,
      converter: (store) => appSettingsSelector(store.state),
      builder: (context, AppSettings settings) {
        Store<AppState> store = StoreProvider.of<AppState>(context);
        void updateDoneColor(Color newDoneColor) => store.dispatch(
              UpdateAppSettingsActions(
                  settings.copyWith(doneColor: newDoneColor)),
            );
        void updateLeftColor(Color newLeftColor) => store.dispatch(
              UpdateAppSettingsActions(
                  settings.copyWith(leftColor: newLeftColor)),
            );

        return Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: ColorSettingsWidget(
                    doneColor: settings.doneColor,
                    leftColor: settings.leftColor,
                    updateDoneColor: updateDoneColor,
                    updateLeftColor: updateLeftColor,
                  ),
                ),
                TextButton(
                  child: Text("Default Progress Duration"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          final yearElements = [];
                          return AlertDialog(
                            title: Text("Default Duration"),
                          );
                        });
                  },
                ),
                FlatButton(
                    onPressed: () {
                      showAboutDialog(
                          context: context,
                          applicationName: TimeProgressTrackerApp.name,
                          applicationVersion: "Beta",
                          applicationLegalese:
                              '\u00a9Andreas Fahrecker 2020-2021');
                    },
                    child: Text("About")),
              ],
            ),
          ),
        );
      },
    );
  }
}
