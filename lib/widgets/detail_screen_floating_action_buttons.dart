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

  DetailScreenFloatingActionButtons({
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

    void _onCancelEditTimeProgressBTN() {
      if (originalProgress == editedProgress)
        onCancelEditProgress();
      else {
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

    void _onDeleteTimeProgressBTN() {
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
            child: editMode ? Icon(Icons.save) : Icon(Icons.edit),
            backgroundColor: editMode ? Colors.green : appTheme.accentColor,
            onPressed: editMode
                ? isEditedProgressValid
                    ? onSaveEditedProgress
                    : null
                : onEditProgress,
          ),
        ),
        Expanded(
          child: FloatingActionButton(
            heroTag: editMode
                ? "cancelEditTimeProgressBTN"
                : "deleteTimeProgressBTN",
            child: editMode ? Icon(Icons.cancel) : Icon(Icons.delete),
            backgroundColor: Colors.red,
            onPressed: editMode
                ? _onCancelEditTimeProgressBTN
                : _onDeleteTimeProgressBTN,
          ),
        ),
      ],
    );
  }
}
