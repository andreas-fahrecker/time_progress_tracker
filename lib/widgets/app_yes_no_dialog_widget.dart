import 'package:flutter/material.dart';

class AppYesNoDialog extends StatelessWidget {
  final String titleText;
  final String contentText;
  final void Function() onYesPressed;

  AppYesNoDialog({
    Key key,
    @required this.titleText,
    @required this.contentText,
    @required this.onYesPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: Text(contentText),
      actions: <Widget>[
        FlatButton(
          child: Text("Yes"),
          onPressed: onYesPressed,
        ),
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
