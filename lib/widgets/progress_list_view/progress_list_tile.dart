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

  Widget _renderSubtitle(BuildContext context) {
    if (!timeProgress.hasStarted())
      return Text("Starts in ${timeProgress.daysTillStart()} Days.");
    if (timeProgress.hasEnded())
      return Text("Ended ${timeProgress.daysSinceEnd()} Days ago.");
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
