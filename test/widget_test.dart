// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_tile.dart';

import 'MaterialTesterWidget.dart';

void main() {
  AppSettings appSettings = AppSettings.defaults();

  testWidgets("Progress Tile has name", (WidgetTester tester) async {
    TimeProgress testProgress =
        TimeProgress("TestProgress", DateTime(2020), DateTime(2021));

    await tester.pumpWidget(
      MaterialTesterWidget(
        widget: ProgressListTile(
            timeProgress: testProgress,
            doneColor: appSettings.doneColor,
            leftColor: appSettings.leftColor),
      ),
    );

    final nameFinder = find.text(testProgress.name);
    expect(nameFinder, findsOneWidget);
  });

  testWidgets("Progress Tile has not started", (WidgetTester tester) async {
    int thisYear = DateTime.now().year;
    TimeProgress notStartedProgress = TimeProgress(
      "TestProgress",
      DateTime(thisYear + 1),
      DateTime(thisYear + 2),
    );

    await tester.pumpWidget(
      MaterialTesterWidget(
        widget: ProgressListTile(
          timeProgress: notStartedProgress,
          doneColor: appSettings.doneColor,
          leftColor: appSettings.leftColor,
        ),
      ),
    );

    final noStartedFinder = find
        .text(ProgressListTileStrings.startsInDaysString(notStartedProgress));
    expect(noStartedFinder, findsOneWidget);
  });
}
