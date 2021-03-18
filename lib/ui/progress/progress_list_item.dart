import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/ui/screens/progress_detail_screen.dart';
import 'package:time_progress_tracker/utils/theme_utils.dart';

class ProgressListTileStrings {
  static String percentString(TimeProgress tp) =>
      "${(tp.percentDone() * 100).floorToDouble()} %";

  static String startsInDaysString(TimeProgress tp) =>
      "Starts in ${tp.daysTillStart()} Days.";

  static String endedDaysAgoString(TimeProgress tp) =>
      "Ended ${tp.daysSinceEnd()} Days ago.";
}

class ProgressListItem extends StatelessWidget {
  final TimeProgress timeProgress;
  final Color doneColor, leftColor;

  ProgressListItem({
    required this.timeProgress,
    required this.doneColor,
    required this.leftColor,
  });

  @override
  Widget build(BuildContext context) {
    void _onTileTap() => Navigator.push(
          context,
          platformPageRoute(
              context: context,
              builder: (context) => ProgressDetailScreen(
                    tpId: timeProgress.id,
                  )),
        );

    Widget _renderTitle(bool material) {
      Text name = Text(
        timeProgress.name,
        style: material ? null : cupertinoCardTitleStyle,
        textAlign: material ? null : TextAlign.left,
      );
      Text duration = Text(
        "${timeProgress.allDays()} Days",
        style: material ? null : cupertinoCardSubtitleStyle,
        textAlign: material ? null : TextAlign.left,
      );
      Row title = Row(
        children: [name, Spacer(), duration],
      );
      if (!material)
        return Padding(
          padding: EdgeInsets.only(bottom: 16, right: 5),
          child: title,
        );
      return title;
    }

    Widget _renderSubtitle(bool material) {
      if (!timeProgress.hasStarted())
        return PlatformText(
            ProgressListTileStrings.startsInDaysString(timeProgress));
      if (timeProgress.hasEnded())
        return PlatformText(
            ProgressListTileStrings.endedDaysAgoString(timeProgress));
      LinearPercentIndicator percentIndicator = LinearPercentIndicator(
        center:
            PlatformText(ProgressListTileStrings.percentString(timeProgress)),
        percent: timeProgress.percentDone(),
        progressColor: doneColor,
        backgroundColor: leftColor,
        lineHeight: 20,
      );
      if (!material)
        return Padding(
          padding: EdgeInsets.only(
            bottom: 5,
            right: 5,
          ),
          child: percentIndicator,
        );
      return percentIndicator;
    }

    Widget _renderCupertino() {
      CupertinoThemeData theme = CupertinoTheme.of(context);
      return CupertinoButton(
          child: Container(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.fromLTRB(15, 15, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _renderTitle(false),
                _renderSubtitle(false),
              ],
            ),
          ),
          onPressed: _onTileTap);
    }

    Widget _renderMaterial() {
      return ListTile(
        title: _renderTitle(true),
        subtitle: _renderSubtitle(true),
        onTap: _onTileTap,
      );
    }

    if (Platform.isIOS) return _renderCupertino();
    return _renderMaterial();
  }
}
