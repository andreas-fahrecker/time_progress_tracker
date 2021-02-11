import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/screens/progress_detail_screen.dart';

class HomeProgressListTile extends StatelessWidget {
  final TimeProgress timeProgress;

  HomeProgressListTile({
    Key key,
    @required this.timeProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget listTileSubTitle;
    if (timeProgress.hasStarted() && !timeProgress.hasEnded())
      listTileSubTitle = LinearPercentIndicator(
        center: Text("${(timeProgress.percentDone() * 100).floor()} %"),
        percent: timeProgress.percentDone(),
        progressColor: Colors.green,
        backgroundColor: Colors.red,
        lineHeight: 20,
      );
    if (!timeProgress.hasStarted())
      listTileSubTitle = Text(
          "Starts in ${timeProgress.startTime.difference(DateTime.now()).inDays} Days");
    if (timeProgress.hasEnded())
      listTileSubTitle = Text(
          "Ended ${DateTime.now().difference(timeProgress.endTime).inDays} Days ago.");

    return Card(
      child: ListTile(
        title: Text(timeProgress.name),
        subtitle: listTileSubTitle,
        onTap: () {
          Navigator.pushNamed(context, ProgressDetailScreen.routeName,
              arguments: ProgressDetailScreenArguments(timeProgress.id));
        },
      ),
    );
  }
}