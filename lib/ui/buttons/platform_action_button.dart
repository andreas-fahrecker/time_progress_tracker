import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:time_progress_tracker/utils/helper_functions.dart';

class PlatformActionButton extends StatelessWidget {
  final String heroTag;
  final IconData icon;
  final void Function() onBtnPressed;

  const PlatformActionButton({
    Key key,
    @required this.heroTag,
    @required this.icon,
    @required this.onBtnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _renderCupertino() {
      return PlatformButton(
        padding: EdgeInsets.all(4),
        child: Icon(
          icon,
          color: Colors.white,
        ),
        onPressed: onBtnPressed,
      );
    }

    Widget _renderMaterial() {
      return FloatingActionButton(
        heroTag: heroTag,
        child: Icon(icon),
        onPressed: onBtnPressed,
      );
    }

    return useCupertino() ? _renderCupertino() : _renderMaterial();
  }
}
