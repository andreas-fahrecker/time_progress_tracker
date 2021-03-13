import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:time_progress_tracker/app.dart';
import 'package:time_progress_tracker/redux/store_connectors/settings_store_connector.dart';
import 'package:time_progress_tracker/ui/buttons/color_picker_btn.dart';
import 'package:time_progress_tracker/ui/settings/duration_settings_widget.dart';

class SettingsScreen extends StatelessWidget {
  Widget _renderColorSettings(
      BuildContext context, SettingsViewModel settingsVm) {
    ThemeData appTheme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Expanded(
              child: PlatformText(
            "Color Settings",
            style: appTheme.primaryTextTheme.caption,
          )),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: ColorPickerButton(
                    title: "Done Color",
                    dialogTitle: "Select Done Color",
                    selectedColor: settingsVm.appSettings.doneColor,
                    onColorPicked: settingsVm.updateDoneColor,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: ColorPickerButton(
                    title: "Left Color",
                    dialogTitle: "Select Left Color",
                    selectedColor: settingsVm.appSettings.leftColor,
                    onColorPicked: settingsVm.updateLeftColor,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsStoreConnector(loadedBuilder: (context, settingsVm) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: _renderColorSettings(context, settingsVm),
              ),
              Expanded(
                child: DurationSettingsWidget(
                  duration: settingsVm.appSettings.duration,
                  updateDuration: settingsVm.updateDuration,
                ),
              ),
              Spacer(),
              Expanded(
                child: PlatformButton(
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
    });
  }
}
