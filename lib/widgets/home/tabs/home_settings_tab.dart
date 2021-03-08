import 'package:flutter/material.dart';
import 'package:time_progress_tracker/app.dart';
import 'package:time_progress_tracker/widgets/home/tabs/settings/color_settings_widget.dart';
import 'package:time_progress_tracker/widgets/home/tabs/settings/duration_settings_widget.dart';
import 'package:time_progress_tracker/widgets/store_connectors/settings_store_connector.dart';

class HomeSettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsStoreConnector(
      loadedBuilder: (context, settingsVm) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: ColorSettingsWidget(
                    doneColor: settingsVm.appSettings.doneColor,
                    leftColor: settingsVm.appSettings.leftColor,
                    updateDoneColor: settingsVm.updateDoneColor,
                    updateLeftColor: settingsVm.updateLeftColor,
                  ),
                ),
                Expanded(
                  child: DurationSettingsWidget(
                    duration: settingsVm.appSettings.duration,
                    updateDuration: settingsVm.updateDuration,
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
