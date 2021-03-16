import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:time_progress_tracker/ui/screens/progress_creation_screen.dart';
import 'package:time_progress_tracker/utils/helper_functions.dart';

class CreateProgressButton extends StatelessWidget {
  final String _heroTag = "createProgressBTN";

  @override
  Widget build(BuildContext context) {
    void _onButtonPressed() => Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (context) => ProgressCreationScreen(),
        ));

    Widget _renderCupertino() {
      return PlatformButton(
        padding: EdgeInsets.all(4),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: _onButtonPressed,
      );
    }

    Widget _renderMaterial() {
      return FloatingActionButton(
        heroTag: _heroTag,
        child: Icon(Icons.add),
        onPressed: _onButtonPressed,
      );
    }

    return useCupertino() ? _renderCupertino() : _renderMaterial();
  }
}
