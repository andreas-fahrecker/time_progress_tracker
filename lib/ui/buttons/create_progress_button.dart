import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:time_progress_tracker/utils/helper_functions.dart';

class CreateProgressButton extends StatelessWidget {
  final String _heroTag = "createTimeProgressBTN";

  final void Function() createProgress;

  const CreateProgressButton({Key? key, required this.createProgress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _renderCupertino() {
      return PlatformButton(
        padding: EdgeInsets.all(4),
        child: Icon(
          Icons.save,
          color: Colors.white,
        ),
        onPressed: () => createProgress(),
      );
    }

    Widget _renderMaterial() {
      return FloatingActionButton(
        heroTag: _heroTag,
        child: Icon(Icons.save),
        onPressed: () => createProgress(),
      );
    }

    return useCupertino() ? _renderCupertino() : _renderMaterial();
  }
}
