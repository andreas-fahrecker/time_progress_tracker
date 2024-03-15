// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_tile.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_view.dart';

import 'material_tester_widget.dart';

void main() {
  final AppSettings defaultAppSettings = AppSettings.defaults();
  final int thisYear = DateTime.now().year;
  final TimeProgress activeProgress = TimeProgress(
      "TestProgress", DateTime(thisYear - 2), DateTime(thisYear + 2));

  void findStringOnce(String str) => expect(find.text(str), findsOneWidget);

  testWidgets("Progress List Tile with currently active progress works",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialTesterWidget(
      widget: ProgressListTile(
        timeProgress: activeProgress,
        doneColor: defaultAppSettings.doneColor,
        leftColor: defaultAppSettings.leftColor,
      ),
    ));

    findStringOnce(activeProgress.name);
    findStringOnce(ProgressListTileStrings.percentString(activeProgress));

    linearPercentPredicate(Widget widget) =>
        widget is LinearPercentIndicator &&
        widget.percent == activeProgress.percentDone() &&
        widget.progressColor == defaultAppSettings.doneColor &&
        widget.backgroundColor == defaultAppSettings.leftColor;
    expect(find.byWidgetPredicate(linearPercentPredicate), findsOneWidget);
  });

  testWidgets("Progress List Tile with future progress works",
      (WidgetTester tester) async {
    TimeProgress futureProgress = TimeProgress(
      "Test Progress",
      DateTime(thisYear + 1),
      DateTime(thisYear + 2),
    );

    await tester.pumpWidget(MaterialTesterWidget(
      widget: ProgressListTile(
        timeProgress: futureProgress,
        doneColor: defaultAppSettings.doneColor,
        leftColor: defaultAppSettings.leftColor,
      ),
    ));

    findStringOnce(futureProgress.name);
    findStringOnce(ProgressListTileStrings.startsInDaysString(futureProgress));
  });

  testWidgets("Progress List Tile with past progress works",
      (WidgetTester tester) async {
    TimeProgress pastProgress = TimeProgress(
      "Test Progress",
      DateTime(thisYear - 2),
      DateTime(thisYear - 1),
    );

    await tester.pumpWidget(MaterialTesterWidget(
      widget: ProgressListTile(
        timeProgress: pastProgress,
        doneColor: defaultAppSettings.doneColor,
        leftColor: defaultAppSettings.leftColor,
      ),
    ));

    findStringOnce(pastProgress.name);
    findStringOnce(ProgressListTileStrings.endedDaysAgoString(pastProgress));
  });

  WidgetPredicate getProgressListTilePredicate(
          TimeProgress tp, AppSettings as) =>
      (Widget widget) =>
          widget is ProgressListTile &&
          widget.timeProgress == tp &&
          widget.doneColor == as.doneColor &&
          widget.leftColor == as.leftColor;

  testWidgets("Progress List View displays one tile",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialTesterWidget(
      widget: ProgressListView(
        timeProgressList: [activeProgress],
        doneColor: defaultAppSettings.doneColor,
        leftColor: defaultAppSettings.leftColor,
      ),
    ));

    findStringOnce(activeProgress.name);
    expect(
        find.byWidgetPredicate(
            getProgressListTilePredicate(activeProgress, defaultAppSettings)),
        findsOneWidget);
  });

  testWidgets("Progress List View displays file tiles",
      (WidgetTester tester) async {
    List<TimeProgress> tpList = [];
    for (int i = 0; i < 5; i++) {
      tpList.add(activeProgress);
    }
    await tester.pumpWidget(MaterialTesterWidget(
      widget: ProgressListView(
        timeProgressList: tpList,
        doneColor: defaultAppSettings.doneColor,
        leftColor: defaultAppSettings.leftColor,
      ),
    ));

    expect(find.text(activeProgress.name), findsNWidgets(5));
    expect(
        find.byWidgetPredicate(
            getProgressListTilePredicate(activeProgress, defaultAppSettings)),
        findsNWidgets(5));
  });
}
