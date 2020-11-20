import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:time_progress_tracker/models/time_progress.dart';

class ProgressDetailLinearPercent extends StatelessWidget {
  final TimeProgress timeProgress;

  ProgressDetailLinearPercent({Key key, @required this.timeProgress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      padding: EdgeInsets.symmetric(horizontal: 15),
      percent: this.timeProgress.percentDone(),
      leading: Text("${this.timeProgress.daysBehind()} Days"),
      center: Text("${(this.timeProgress.percentDone() * 100).floor()} %"),
      trailing: Text("${this.timeProgress.daysLeft()} Days"),
      progressColor: Colors.green,
      backgroundColor: Colors.red,
      lineHeight: 25,
    );
  }
}
