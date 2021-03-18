import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_progress_tracker/ui/buttons/platform_action_button.dart';

class DetailScreenTrailingButton extends StatelessWidget {
  final bool isEditMode;
  final void Function() cancelEditTp, deleteTp;

  const DetailScreenTrailingButton({
    Key? key,
    required this.isEditMode,
    required this.cancelEditTp,
    required this.deleteTp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEditMode)
      return PlatformActionButton(
          heroTag: "cancelEditTimeProgressBTN",
          icon: Icons.cancel,
          materialBackground: Colors.red,
          onBtnPressed: cancelEditTp);
    return PlatformActionButton(
      heroTag: "deleteTimeProgressBTN",
      icon: Icons.delete,
      materialBackground: Colors.red,
      onBtnPressed: deleteTp,
    );
  }
}
