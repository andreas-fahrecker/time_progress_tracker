import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:time_progress_tracker/utils/helper_functions.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_view.dart';
import 'package:time_progress_tracker/widgets/store_connectors/settings_store_connector.dart';
import 'package:time_progress_tracker/widgets/store_connectors/time_progress_list_store_connector.dart';

class InactiveTimeProgressesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsStoreConnector(loadedBuilder: (context, settingsVm) {
      return TimeProgressListStoreConnector(loadedBuilder: (context, tpListVm) {
        List<TimeProgress> activeTpList =
            selectInactiveProgresses(tpListVm.tpList);
        if (activeTpList.length < 1)
          return Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: PlatformText(
                  "You don't have any inactive time progress, that are tracked."),
            ),
          );
        return ProgressListView(
          timeProgressList: activeTpList,
          doneColor: settingsVm.appSettings.doneColor,
          leftColor: settingsVm.appSettings.leftColor,
        );
      });
    });
  }
}
