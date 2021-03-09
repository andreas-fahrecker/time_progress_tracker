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
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_item.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_view.dart';

import 'MaterialTesterWidget.dart';

void main() {
  final AppSettings _defaultAppSettings = AppSettings.defaults();
  final int _thisYear = DateTime.now().year;
  final TimeProgress _activeProgress = TimeProgress(
      "TestProgress", DateTime(_thisYear - 2), DateTime(_thisYear + 2));

  void _findStringOnce(String str) => expect(find.text(str), findsOneWidget);

  testWidgets("Progress List Tile with currently active progress works",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialTesterWidget(
      widget: ProgressListItem(
        timeProgress: _activeProgress,
        doneColor: _defaultAppSettings.doneColor,
        leftColor: _defaultAppSettings.leftColor,
      ),
    ));

    _findStringOnce(_activeProgress.name);
    _findStringOnce(ProgressListTileStrings.percentString(_activeProgress));

    WidgetPredicate linearPercentPredicate = (Widget widget) =>
        widget is LinearPercentIndicator &&
        widget.percent == _activeProgress.percentDone() &&
        widget.progressColor == _defaultAppSettings.doneColor &&
        widget.backgroundColor == _defaultAppSettings.leftColor;
    expect(find.byWidgetPredicate(linearPercentPredicate), findsOneWidget);
  });

  testWidgets("Progress List Tile with future progress works",
      (WidgetTester tester) async {
    TimeProgress futureProgress = TimeProgress(
      "Test Progress",
      DateTime(_thisYear + 1),
      DateTime(_thisYear + 2),
    );

    await tester.pumpWidget(MaterialTesterWidget(
      widget: ProgressListItem(
        timeProgress: futureProgress,
        doneColor: _defaultAppSettings.doneColor,
        leftColor: _defaultAppSettings.leftColor,
      ),
    ));

    _findStringOnce(futureProgress.name);
    _findStringOnce(ProgressListTileStrings.startsInDaysString(futureProgress));
  });

  testWidgets("Progress List Tile with past progress works",
      (WidgetTester tester) async {
    TimeProgress pastProgress = TimeProgress(
      "Test Progress",
      DateTime(_thisYear - 2),
      DateTime(_thisYear - 1),
    );

    await tester.pumpWidget(MaterialTesterWidget(
      widget: ProgressListItem(
        timeProgress: pastProgress,
        doneColor: _defaultAppSettings.doneColor,
        leftColor: _defaultAppSettings.leftColor,
      ),
    ));

    _findStringOnce(pastProgress.name);
    _findStringOnce(ProgressListTileStrings.endedDaysAgoString(pastProgress));
  });

  WidgetPredicate getProgressListTilePredicate(
          TimeProgress tp, AppSettings as) =>
      (Widget widget) =>
          widget is ProgressListItem &&
          widget.timeProgress == tp &&
          widget.doneColor == as.doneColor &&
          widget.leftColor == as.leftColor;

  testWidgets("Progress List View displays one tile",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialTesterWidget(
      widget: ProgressListView(
        timeProgressList: [_activeProgress],
        doneColor: _defaultAppSettings.doneColor,
        leftColor: _defaultAppSettings.leftColor,
      ),
    ));

    _findStringOnce(_activeProgress.name);
    expect(
        find.byWidgetPredicate(
            getProgressListTilePredicate(_activeProgress, _defaultAppSettings)),
        findsOneWidget);
  });

  testWidgets("Progress List View displays file tiles",
      (WidgetTester tester) async {
    List<TimeProgress> tpList = [];
    for (int i = 0; i < 5; i++) tpList.add(_activeProgress);
    await tester.pumpWidget(MaterialTesterWidget(
      widget: ProgressListView(
        timeProgressList: tpList,
        doneColor: _defaultAppSettings.doneColor,
        leftColor: _defaultAppSettings.leftColor,
      ),
    ));

    expect(find.text(_activeProgress.name), findsNWidgets(5));
    expect(
        find.byWidgetPredicate(
            getProgressListTilePredicate(_activeProgress, _defaultAppSettings)),
        findsNWidgets(5));
  });
}
