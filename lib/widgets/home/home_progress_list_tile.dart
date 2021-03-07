import 'package:flutter/material.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_tile.dart';

class HomeProgressListTile extends StatelessWidget {
  final TimeProgress timeProgress;
  final Color doneColor;
  final Color leftColor;

  HomeProgressListTile({
    @required this.timeProgress,
    @required this.doneColor,
    @required this.leftColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ProgressListTile(
        timeProgress: timeProgress,
        doneColor: doneColor,
        leftColor: leftColor,
      ),
    );
  }
}
