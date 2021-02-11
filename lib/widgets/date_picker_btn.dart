import 'package:flutter/material.dart';

class DatePickerBtn extends StatelessWidget {
  final String leadingString;
  final DateTime pickedDate;
  final void Function(DateTime) onDatePicked;

  DatePickerBtn({
    @required this.leadingString,
    @required this.pickedDate,
    @required this.onDatePicked,
  }) : super();

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    return FlatButton(
      onPressed: () async {
        onDatePicked(await showDatePicker(
          context: context,
          initialDate: pickedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        ));
      },
      child: Text(
          "$leadingString ${pickedDate.toLocal().toString().split(" ")[0]}"),
      color: appTheme.accentColor,
    );
  }
}
