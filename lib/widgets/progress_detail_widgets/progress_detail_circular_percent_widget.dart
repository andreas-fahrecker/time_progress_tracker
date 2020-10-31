import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressDetailCircularPercent extends StatelessWidget {
  final double percentDone;

  ProgressDetailCircularPercent({Key key, @required this.percentDone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 100,
      lineWidth: 10,
      percent: percentDone,
      progressColor: Colors.green,
      backgroundColor: Colors.red,
      center: Text("${(percentDone * 100).floor()} %"),
    );
  }
}
