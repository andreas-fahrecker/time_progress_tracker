import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/selectors/time_progress_selectors.dart';
import 'package:time_progress_tracker/widgets/home/home_progress_list_tile.dart';

class HomeActiveProgressesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      onInit: loadTimeProgressListIfUnloaded,
      converter: (store) => store.state.hasProgressesLoaded,
      builder: (context, hasLoaded) {
        if (!(hasLoaded as bool))
          return Center(
            child: CircularProgressIndicator(),
          );
        return StoreConnector<AppState, AppSettings>(
          onInit: loadSettingsIfUnloaded,
          converter: (store) => appSettingsSelector(store.state),
          builder: (context, AppSettings settings) {
            if (settings == null)
              return Center(child: CircularProgressIndicator());
            return StoreConnector<AppState, List<TimeProgress>>(
              converter: (store) => activeTimeProgressesSelector(store.state),
              builder: (context, List<TimeProgress> timeProgresses) {
                if (timeProgresses.length < 1)
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                          "You don't have any currently active time progresses, that are tracked."),
                    ),
                  );
                return ListView(
                  padding: EdgeInsets.all(8),
                  children: timeProgresses
                      .map((timeProgress) => HomeProgressListTile(
                            timeProgress: timeProgress,
                            doneColor: settings.doneColor,
                            leftColor: settings.leftColor,
                          ))
                      .toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}
