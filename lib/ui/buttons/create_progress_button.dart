import 'package:flutter/material.dart';
import 'package:time_progress_tracker/ui/screens/progress_creation_screen.dart';

class CreateProgressButton extends StatelessWidget {
  final String _heroTag = "createProgressBTN";

  @override
  Widget build(BuildContext context) {
    void _onButtonPressed() =>
        Navigator.pushNamed(context, ProgressCreationScreen.routeName);

    return FloatingActionButton(
      heroTag: _heroTag,
      child: Icon(Icons.add),
      onPressed: _onButtonPressed,
    );
  }
}
