import 'package:flutter/material.dart';
import 'package:time_progress_tracker/screens/progress_creation_screen.dart';
import 'package:time_progress_tracker/widgets/home_widgets/home_bottom_navbar.dart';
import 'package:time_progress_tracker/widgets/home_widgets/home_active_progresses_tab.dart';
import 'package:time_progress_tracker/widgets/home_widgets/home_inactive_progresses_tab.dart';
import 'package:time_progress_tracker/widgets/home_widgets/home_settings_tab.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  static const title = "Time Progress Tracker";

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeActiveProgressesTab(),
    HomeInactiveProgressesTab(),
    HomeSettingsTab(),
  ];

  void onBottomTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(HomeScreen.title),
      ),
      body: _children[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _currentIndex != 2
          ? FloatingActionButton(
              heroTag: "createProgressBTN",
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, ProgressCreationScreen.routeName);
              },
            )
          : null,
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentIndex,
        onTap: onBottomTabTapped,
      ),
    );
  }
}