import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:time_progress_tracker/models/time_progress.dart';

class ProgressListTile extends StatelessWidget {
  final TimeProgress timeProgress;
  final Color doneColor, leftColor;

  ProgressListTile({
    @required this.timeProgress,
    @required this.doneColor,
    @required this.leftColor,
  });

  String percentString() =>
      "${(this.timeProgress.percentDone() * 100).floorToDouble()} %";

  String startsInDaysString() =>
      "Starts in ${timeProgress.daysTillStart()} Days.";

  String endedDaysAgoString() =>
      "Ended ${timeProgress.daysSinceEnd()} Days ago.";

  Widget _renderSubtitle(BuildContext context) {
    if (!timeProgress.hasStarted()) return Text(startsInDaysString());
    if (timeProgress.hasEnded()) return Text(endedDaysAgoString());
    return LinearPercentIndicator(
      center: Text(percentString()),
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
