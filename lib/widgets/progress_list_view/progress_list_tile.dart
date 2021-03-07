import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:time_progress_tracker/models/time_progress.dart';

class ProgressListTileStrings {
  static String percentString(TimeProgress tp) =>
      "${(tp.percentDone() * 100).floorToDouble()} %";

  static String startsInDaysString(TimeProgress tp) =>
      "Starts in ${tp.daysTillStart()} Days.";

  static String endedDaysAgoString(TimeProgress tp) =>
      "Ended ${tp.daysSinceEnd()} Days ago.";
}

class ProgressListTile extends StatelessWidget {
  final TimeProgress timeProgress;
  final Color doneColor, leftColor;

  ProgressListTile({
    @required this.timeProgress,
    @required this.doneColor,
    @required this.leftColor,
  });

  Widget _renderSubtitle(BuildContext context) {
    if (!timeProgress.hasStarted())
      return Text(ProgressListTileStrings.startsInDaysString(timeProgress));
    if (timeProgress.hasEnded())
      return Text(ProgressListTileStrings.endedDaysAgoString(timeProgress));
    return LinearPercentIndicator(
      center: Text(ProgressListTileStrings.percentString(timeProgress)),
      percent: timeProgress.percentDone(),
      progressColor: doneColor,
      backgroundColor: leftColor,
      lineHeight: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(timeProgress.name),
      subtitle: _renderSubtitle(context),
    );
  }
}
