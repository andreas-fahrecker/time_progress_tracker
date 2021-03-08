import 'package:flutter/material.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_tile.dart';

class ProgressListView extends StatelessWidget {
  final List<TimeProgress> timeProgressList;
  final Color doneColor, leftColor;

  ProgressListView({
    @required this.timeProgressList,
    @required this.doneColor,
    @required this.leftColor,
  });

  List<Widget> _renderListViewChildren() {
    return timeProgressList
        .map((e) => Card(
              child: ProgressListTile(
                timeProgress: e,
                doneColor: doneColor,
                leftColor: leftColor,
              ),
            ))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8),
      children: _renderListViewChildren(),
    );
  }
}
