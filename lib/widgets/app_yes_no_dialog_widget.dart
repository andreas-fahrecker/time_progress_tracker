import 'package:flutter/material.dart';

class AppYesNoDialog extends StatelessWidget {
  final String titleText;
  final String contentText;
  final void Function() onYesPressed;

  const AppYesNoDialog({
    super.key,
    required this.titleText,
    required this.contentText,
    required this.onYesPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: Text(contentText),
      actions: <Widget>[
        TextButton(
          onPressed: onYesPressed,
          child: const Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("No"),
        )
      ],
    );
  }
}
