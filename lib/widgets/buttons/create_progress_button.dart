import 'package:flutter/material.dart';
import 'package:time_progress_tracker/screens/progress_creation_screen.dart';

class CreateProgressButton extends StatelessWidget {
  final String _heroTag = "createProgressBTN";

  const CreateProgressButton({super.key});

  @override
  Widget build(BuildContext context) {
    void onButtonPressed() =>
        Navigator.pushNamed(context, ProgressCreationScreen.routeName);

    return FloatingActionButton(
      heroTag: _heroTag,
      onPressed: onButtonPressed,
      child: const Icon(Icons.add),
    );
  }
}
