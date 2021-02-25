import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/app.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';

class HomeSettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppSettings>(
      onInit: loadSettingsIfUnloaded,
      converter: (store) => appSettingsSelector(store.state),
      builder: (context, AppSettings settings) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Text("Color Settings",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87)),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: TextButton(
                          child: Text("Done Color"),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: settings.doneColor,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  Store<AppState> store =
                                      StoreProvider.of<AppState>(context);
                                  return AlertDialog(
                                    title: Text("Select a Done Color"),
                                    content: SingleChildScrollView(
                                      child: BlockPicker(
                                        pickerColor: settings.doneColor,
                                        onColorChanged: (c) => store.dispatch(
                                            UpdateAppSettingsActions(settings
                                                .copyWith(doneColor: c))),
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: TextButton(
                        child: Text("Left Color"),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: settings.leftColor,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text("Select a Left Color"),
                                    content: SingleChildScrollView(
                                        child: BlockPicker(
                                      pickerColor: settings.leftColor,
                                      onColorChanged: (c) => StoreProvider.of<
                                              AppState>(context)
                                          .dispatch(UpdateAppSettingsActions(
                                              settings.copyWith(leftColor: c))),
                                    )));
                              });
                        },
                      ),
                    ))
                  ],
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
