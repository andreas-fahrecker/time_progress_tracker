import 'package:flutter_test/flutter_test.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_tile.dart';

import 'MaterialTesterWidget.dart';

class ProgressListTileTester {
  AppSettings _appSettings;

  void initTests() {
    _appSettings = AppSettings.defaults();
  }

  void testName() {
    testWidgets("Progress Tile has name", (WidgetTester tester) async {
      TimeProgress testProgress =
          TimeProgress("TestProgress", DateTime(2020), DateTime(2021));

      await tester.pumpWidget(
        MaterialTesterWidget(
          widget: ProgressListTile(
              timeProgress: testProgress,
              doneColor: _appSettings.doneColor,
              leftColor: _appSettings.leftColor),
        ),
      );

      final nameFinder = find.text(testProgress.name);
      expect(nameFinder, findsOneWidget);
    });
  }

  void notStartedTest() {
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
            doneColor: _appSettings.doneColor,
            leftColor: _appSettings.leftColor,
          ),
        ),
      );

      final noStartedFinder = find
          .text(ProgressListTileStrings.startsInDaysString(notStartedProgress));
      expect(noStartedFinder, findsOneWidget);
    });
  }
}
