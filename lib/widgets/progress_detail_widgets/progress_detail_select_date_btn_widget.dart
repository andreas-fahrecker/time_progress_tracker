import 'package:flutter/material.dart';

class ProgressDetailSelectDateButton extends StatelessWidget {
  final String leadingString;
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  ProgressDetailSelectDateButton({
    Key key,
    @required this.leadingString,
    @required this.selectedDate,
    @required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      child: Text(
          "$leadingString ${selectedDate.toLocal().toString().split(" ")[0]}"),
      onPressed: () async {
        DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(selectedDate.year - 5),
          lastDate: DateTime(selectedDate.year + 5),
        );
        onDateSelected(picked);
      },
    );
  }
}
