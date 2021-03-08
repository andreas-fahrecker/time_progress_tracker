import 'package:flutter_test/flutter_test.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_tile.dart';
import 'package:time_progress_tracker/widgets/progress_list_view/progress_list_view.dart';

import 'MaterialTesterWidget.dart';

class ProgressListViewTester {
  AppSettings _appSettings;
  final int _thisYear = DateTime.now().year;

  void initTests() {
    _appSettings = AppSettings.defaults();
  }

  void testOneName() {
    testWidgets("Progress List View has one name", (WidgetTester tester) async {
      TimeProgress testProgress =
          TimeProgress("TestProgress", DateTime(2020), DateTime(2021));

      await tester.pumpWidget(MaterialTesterWidget(
        widget: ProgressListView(
          timeProgressList: [testProgress],
          doneColor: _appSettings.doneColor,
          leftColor: _appSettings.leftColor,
        ),
      ));

      final nameFinder = find.text(testProgress.name);
      expect(nameFinder, findsOneWidget);
    });
  }

  void testFiveName() {
    testWidgets("Progress List View has one name", (WidgetTester tester) async {
      List<TimeProgress> testProgressList = List();
      for (int i = 0; i < 5; i++)
        testProgressList.add(
            TimeProgress("TestProgress $i", DateTime(2020), DateTime(2021)));

      await tester.pumpWidget(MaterialTesterWidget(
        widget: ProgressListView(
          timeProgressList: testProgressList,
          doneColor: _appSettings.doneColor,
          leftColor: _appSettings.leftColor,
        ),
      ));

      final List<Finder> nameFinderList =
          testProgressList.map((tp) => find.text(tp.name));
      nameFinderList.forEach((nf) => expect(nf, findsOneWidget));
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

  void alreadyEndedTest() {
    testWidgets("Progress List Tile has already ended",
        (WidgetTester tester) async {
      TimeProgress alreadyEndedProgress = TimeProgress(
        "TestProgress",
        DateTime(_thisYear - 2),
        DateTime(_thisYear - 1),
      );

      await tester.pumpWidget(
        MaterialTesterWidget(
          widget: ProgressListTile(
            timeProgress: alreadyEndedProgress,
            doneColor: _appSettings.doneColor,
            leftColor: _appSettings.leftColor,
          ),
        ),
      );

      final alreadyEndedFinder = find.text(
          ProgressListTileStrings.endedDaysAgoString(alreadyEndedProgress));
      expect(alreadyEndedFinder, findsOneWidget);
    });
  }
}
