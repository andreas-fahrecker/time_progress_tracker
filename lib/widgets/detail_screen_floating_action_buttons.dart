import 'package:flutter/material.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/app_yes_no_dialog_widget.dart';

class DetailScreenFloatingActionButtons extends StatelessWidget {
  final bool editMode, isEditedProgressValid;
  final TimeProgress originalProgress, editedProgress;
  final void Function() onEditProgress,
      onSaveEditedProgress,
      onCancelEditProgress,
      onDeleteProgress;

  const DetailScreenFloatingActionButtons({
    super.key,
    @required this.editMode,
    @required this.originalProgress,
    @required this.editedProgress,
    @required this.isEditedProgressValid,
    @required this.onEditProgress,
    @required this.onSaveEditedProgress,
    @required this.onCancelEditProgress,
    @required this.onDeleteProgress,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData appTheme = Theme.of(context);

    void onCancelEditTimeProgressBTN() {
      if (originalProgress == editedProgress) {
        onCancelEditProgress();
      } else {
        showDialog(
          context: context,
          builder: (_) => AppYesNoDialog(
            titleText: "Cancel Editing of ${originalProgress.name}",
            contentText:
                "Are you sure that you want to discard the changes done to ${originalProgress.name}",
            onYesPressed: () {
              onCancelEditProgress();
              Navigator.pop(context);
            },
          ),
        );
      }
    }

    void onDeleteTimeProgressBTN() {
      showDialog(
        context: context,
        builder: (_) => AppYesNoDialog(
          titleText: "Delete ${originalProgress.name}",
          contentText: "Are you sure you want to delete this time progress?",
          onYesPressed: onDeleteProgress,
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: FloatingActionButton(
            heroTag:
                editMode ? "saveEditedTimeProgressBTN" : "editTimeProgressBTN",
            backgroundColor: editMode ? Colors.green : appTheme.accentColor,
            onPressed: editMode
                ? isEditedProgressValid
                    ? onSaveEditedProgress
                    : null
                : onEditProgress,
            child: editMode ? const Icon(Icons.save) : const Icon(Icons.edit),
          ),
        ),
        Expanded(
          child: FloatingActionButton(
            heroTag: editMode
                ? "cancelEditTimeProgressBTN"
                : "deleteTimeProgressBTN",
            backgroundColor: Colors.red,
            onPressed: editMode
                ? onCancelEditTimeProgressBTN
                : onDeleteTimeProgressBTN,
            child: editMode ? const Icon(Icons.cancel) : const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
