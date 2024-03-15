import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function onTap;

  const HomeBottomNavBar({
    super.key,
    @required this.currentIndex,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);

    return BottomNavigationBar(
      onTap: onTap,
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.alarm,
            color: appTheme.primaryColor,
          ),
          label: "Active Progresses",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.alarm_off,
            color: appTheme.primaryColor,
          ),
          label: "Inactive Progresses",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: appTheme.primaryColor,
          ),
          label: "Settings",
        )
      ],
    );
  }
}
