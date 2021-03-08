import 'package:flutter/material.dart';
import 'package:time_progress_tracker/helper_functions.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_view.dart';
import 'package:time_progress_tracker/widgets/store_connectors/settings_store_connector.dart';
import 'package:time_progress_tracker/widgets/store_connectors/time_progress_list_store_connector.dart';

class HomeInactiveProgressesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsStoreConnector(
      loadedBuilder: (context, settingsVm) {
        return TimeProgressListStoreConnector(
          loadedBuilder: (context, tpListVm) {
            List<TimeProgress> inactiveTpList =
                selectInactiveProgresses(tpListVm.tpList);
            if (inactiveTpList.length < 1)
              return Container(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                      "You don't have any currently inactive time progresses, that are tracked."),
                ),
              );

            return ProgressListView(
              timeProgressList: inactiveTpList,
              doneColor: settingsVm.appSettings.doneColor,
              leftColor: settingsVm.appSettings.leftColor,
            );
          },
        );
      },
    );
  }
}
