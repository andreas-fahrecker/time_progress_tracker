import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:time_progress_tracker/app.dart';

class HomeSettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            Text("The Settings of this App are not yet implemented."),
            FlatButton(
                onPressed: () {
                  showAboutDialog(
                      context: context,
                      applicationName: TimeProgressTrackerApp.name,
                      applicationVersion: "Beta",
                      applicationLegalese: '\u00a9Andreas Fahrecker 2020-2021');
                },
                child: Text("About"))
          ],
        ),
      ),
    );
  }
}
