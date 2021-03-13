import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/ui/progress/progress_list_item.dart';

class ProgressListView extends StatelessWidget {
  final List<TimeProgress> timeProgressList;
  final Color doneColor, leftColor;

  ProgressListView({
    @required this.timeProgressList,
    @required this.doneColor,
    @required this.leftColor,
  });

  Widget _renderListTile(TimeProgress tp) {
    ProgressListItem listTile = ProgressListItem(
        timeProgress: tp, doneColor: doneColor, leftColor: leftColor);
    if (Platform.isIOS) return listTile;
    return Card(
      child: listTile,
    );
  }

  List<Widget> _renderListViewChildren() {
    return timeProgressList
        .map((e) => _renderListTile(e))
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
