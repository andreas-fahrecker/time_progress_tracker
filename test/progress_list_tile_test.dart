import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_tile.dart';

import 'MaterialTesterWidget.dart';

class ProgressListTileTester {
  AppSettings _appSettings;
  final int _thisYear = DateTime.now().year;

  void initTests() {
    _appSettings = AppSettings.defaults();
  }

  void _verifyNameWorks(String name) => expect(find.text(name), findsOneWidget);

  void testCurrentlyActiveProgress() {
    testWidgets("Progress List Tile with currently active progress works",
        (WidgetTester tester) async {
      TimeProgress testProgress = TimeProgress(
          "TestProgress", DateTime(_thisYear - 2), DateTime(_thisYear + 2));

      await tester.pumpWidget(MaterialTesterWidget(
        widget: ProgressListTile(
            timeProgress: testProgress,
            doneColor: _appSettings.doneColor,
            leftColor: _appSettings.leftColor),
      ));

      _verifyNameWorks(testProgress.name);
      expect(find.text(ProgressListTileStrings.percentString(testProgress)),
          findsOneWidget);

      WidgetPredicate linearPercentPredicate = (Widget widget) =>
          widget is LinearPercentIndicator &&
          widget.percent == testProgress.percentDone() &&
          widget.progressColor == _appSettings.doneColor &&
          widget.backgroundColor == _appSettings.leftColor;
      expect(find.byWidgetPredicate(linearPercentPredicate), findsOneWidget);
    });
  }

  void notStartedTest() {
    testWidgets("Progress List Tile has not started",
        (WidgetTester tester) async {
      TimeProgress notStartedProgress = TimeProgress(
        "TestProgress",
        DateTime(_thisYear + 1),
        DateTime(_thisYear + 2),
      );

      await tester.pumpWidget(MaterialTesterWidget(
        widget: ProgressListTile(
          timeProgress: notStartedProgress,
          doneColor: _appSettings.doneColor,
          leftColor: _appSettings.leftColor,
        ),
      ));

      final noStartedFinder = find
          .text(ProgressListTileStrings.startsInDaysString(notStartedProgress));
      expect(noStartedFinder, findsOneWidget);
    });
  }

  void alreadyEndedTest() {
    testWidgets("Progress List Tile has already ended",
        (WidgetTester tester) async {
      TimeProgress alreadyEndedProgress = TimeProgress(
        "TestProgress",
        DateTime(_thisYear - 2),
        DateTime(_thisYear - 1),
      );

      await tester.pumpWidget(MaterialTesterWidget(
        widget: ProgressListTile(
          timeProgress: alreadyEndedProgress,
          doneColor: _appSettings.doneColor,
          leftColor: _appSettings.leftColor,
        ),
      ));

      final alreadyEndedFinder = find.text(
          ProgressListTileStrings.endedDaysAgoString(alreadyEndedProgress));
      expect(alreadyEndedFinder, findsOneWidget);
    });
  }
}
