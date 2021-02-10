import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function onTap;

  HomeBottomNavBar({
    Key key,
    @required this.currentIndex,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);

    return BottomNavigationBar(
      onTap: onTap,
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: new Icon(
            Icons.alarm,
            color: appTheme.primaryColor,
          ),
          label: "Active Progresses",
        ),
        BottomNavigationBarItem(
          icon: new Icon(
            Icons.alarm_off,
            color: appTheme.primaryColor,
          ),
          label: "Inactive Progresses",
        ),
        BottomNavigationBarItem(
          icon: new Icon(
            Icons.settings,
            color: appTheme.primaryColor,
          ),
          label: "Settings",
        )
      ],
    );
  }
}
