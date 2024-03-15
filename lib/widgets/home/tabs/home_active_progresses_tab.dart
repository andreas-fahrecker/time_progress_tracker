import 'package:flutter/material.dart';
import 'package:time_progress_tracker/helper_functions.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_view.dart';
import 'package:time_progress_tracker/widgets/store_connectors/settings_store_connector.dart';
import 'package:time_progress_tracker/widgets/store_connectors/time_progress_list_store_connector.dart';

class HomeActiveProgressesTab extends StatelessWidget {
  const HomeActiveProgressesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsStoreConnector(
      loadedBuilder: (context, settingsVm) {
        return TimeProgressListStoreConnector(
          loadedBuilder: (context, tpListVm) {
            List<TimeProgress> activeTpList =
                selectActiveProgresses(tpListVm.tpList);
            if (activeTpList.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: Text(
                      "You don't have any active time progress, that are tracked."),
                ),
              );
            }

            return ProgressListView(
              timeProgressList: activeTpList,
              doneColor: settingsVm.appSettings.doneColor,
              leftColor: settingsVm.appSettings.leftColor,
            );
          },
        );
      },
    );
  }
}
