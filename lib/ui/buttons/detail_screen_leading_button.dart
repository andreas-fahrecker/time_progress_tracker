import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_progress_tracker/ui/buttons/platform_action_button.dart';

class DetailScreenLeadingButton extends StatelessWidget {
  final bool isEditMode, isEditedTpValid;
  final void Function() saveTp, editTp;

  const DetailScreenLeadingButton({
    Key? key,
    required this.isEditMode,
    required this.isEditedTpValid,
    required this.saveTp,
    required this.editTp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData materialTheme = Theme.of(context);

    if (isEditMode)
      return PlatformActionButton(
          heroTag: "saveEditedTimeProgressBTN",
          icon: Icons.save,
          materialBackground: Colors.green,
          onBtnPressed: isEditedTpValid ? saveTp : null);
    return PlatformActionButton(
      heroTag: "editTimeProgressBTN",
      icon: Icons.edit,
      materialBackground: materialTheme.accentColor,
      onBtnPressed: editTp,
    );
  }
}
