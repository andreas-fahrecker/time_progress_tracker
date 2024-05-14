import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:time_progress_tracker/models/time_progress.dart';

class ProgressViewWidget extends StatelessWidget {
  final TimeProgress timeProgress;
  final Color doneColor;
  final Color leftColor;

  const ProgressViewWidget({
    super.key,
    required this.timeProgress,
    required this.doneColor,
    required this.leftColor,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.3, // adjust the value as needed
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                timeProgress.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.3, // adjust the value as needed
            child: CircularPercentIndicator(
              radius: 100,
              lineWidth: 10,
              percent: timeProgress.percentDone(),
              progressColor: doneColor,
              backgroundColor: leftColor,
              center: Text("${(timeProgress.percentDone() * 100).floor()} %"),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.3, // adjust the value as needed
            child: LinearPercentIndicator(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              percent: timeProgress.percentDone(),
              leading: Text("${timeProgress.daysBehind()} Days"),
              center: Text(
                "${(timeProgress.percentDone() * 100).floor()} %",
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Text("${timeProgress.daysLeft()} Days"),
              progressColor: doneColor,
              backgroundColor: leftColor,
              lineHeight: 25,
            ),
          ),
        ],
      ),
    );
  }
}
