import 'package:flutter/material.dart';

class ProgressDetailFabEditingRow extends StatelessWidget {
  final void Function() onSave;
  final void Function() onCancelEdit;

  ProgressDetailFabEditingRow({
    Key key,
    @required this.onSave,
    @required this.onCancelEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FloatingActionButton(
            heroTag: "saveEditedTimeProgressBTN",
            child: Icon(Icons.save),
            backgroundColor: Colors.green,
            onPressed: this.onSave,
          ),
        ),
        Expanded(
            child: FloatingActionButton(
          heroTag: "cancelEditTimeProgressBTN",
          child: Icon(Icons.cancel),
          backgroundColor: Colors.red,
          onPressed: this.onCancelEdit,
        ))
      ],
    );
  }
}
