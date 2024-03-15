import 'package:flutter/material.dart';
import 'package:time_progress_tracker/widgets/buttons/create_progress_button.dart';
import 'package:time_progress_tracker/widgets/home/home_bottom_navbar.dart';
import 'package:time_progress_tracker/widgets/home/tabs/home_active_progresses_tab.dart';
import 'package:time_progress_tracker/widgets/home/tabs/home_inactive_progresses_tab.dart';
import 'package:time_progress_tracker/widgets/home/tabs/home_settings_tab.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  static const title = "Time Progress Tracker";

  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomeActiveProgressesTab(),
    const HomeInactiveProgressesTab(),
    const HomeSettingsTab(),
  ];

  void onBottomTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomeScreen.title),
      ),
      body: _children[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _currentIndex != 2 ? const CreateProgressButton() : null,
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentIndex,
        onTap: onBottomTabTapped,
      ),
    );
  }
}
