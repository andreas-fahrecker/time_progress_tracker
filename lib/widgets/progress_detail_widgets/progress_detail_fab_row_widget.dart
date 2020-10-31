import 'package:flutter/material.dart';

class ProgressDetailFabRow extends StatelessWidget {
  final void Function() onEdit;
  final void Function() onDelete;

  ProgressDetailFabRow(
      {Key key, @required this.onEdit, @required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FloatingActionButton(
            heroTag: "editTimeProgressBTN",
            child: Icon(Icons.edit),
            onPressed: onEdit,
          ),
        ),
        Expanded(
          child: FloatingActionButton(
            heroTag: "deleteTimeProgressBTN",
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            onPressed: onDelete,
          ),
        )
      ],
    );
  }
}
