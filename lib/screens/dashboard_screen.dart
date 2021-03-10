import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:time_progress_tracker/screens/active_time_progresses_screen.dart';
import 'package:time_progress_tracker/screens/inactive_time_progresses_screen.dart';
import 'package:time_progress_tracker/screens/settings_screen.dart';
import 'package:time_progress_tracker/utils/color_utils.dart';
import 'package:time_progress_tracker/utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _tabSelectedIndex = 0;
  String title = txtActiveProgressesScreen;

  Widget _renderTabScreen(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return InactiveTimeProgressesScreen();
      case 2:
        return SettingsScreen();
      default:
        return ActiveTimeProgressesScreen();
    }
  }

  String getScreenTitle(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return txtInactiveProgressesScreen;
      case 2:
        return txtSettingsScreen;
      default:
        return txtActiveProgressesScreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(
          title,
          style: toolbarTextStyle,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          transitionBetweenRoutes: false,
        ),
      ),
      material: (_, __) => MaterialScaffoldData(),
      body: _renderTabScreen(_tabSelectedIndex),
      bottomNavBar: PlatformNavBar(
          currentIndex: _tabSelectedIndex,
          itemChanged: (index) {
            setState(() {
              _tabSelectedIndex = index;
              title = getScreenTitle(index);
            });
          },
          backgroundColor: bottomTabsBackground,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm, color: Colors.grey),
              label: txtActiveProgressesScreen,
              activeIcon: Icon(Icons.alarm, color: Colors.white),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm_off, color: Colors.grey),
              label: txtInactiveProgressesScreen,
              activeIcon: Icon(Icons.alarm_off, color: Colors.white),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: Colors.grey),
              label: txtSettingsScreen,
              activeIcon: Icon(Icons.settings, color: Colors.white),
            )
          ]),
    );
  }
}
