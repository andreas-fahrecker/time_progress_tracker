import 'package:flutter/material.dart';
import 'package:time_progress_calculator/widgets/progress_detail_widgets/progress_detail_select_date_btn_widget.dart';

class ProgressDetailEditDatesRow extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final void Function(DateTime) onStartTimeChanged;
  final void Function(DateTime) onEndTimeChanged;

  ProgressDetailEditDatesRow({
    Key key,
    @required this.startTime,
    @required this.endTime,
    @required this.onStartTimeChanged,
    @required this.onEndTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: ProgressDetailSelectDateButton(
            leadingString: "Start Date:",
            selectedDate: startTime,
            onDateSelected: onStartTimeChanged,
          ),
        ),
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 5,
          child: ProgressDetailSelectDateButton(
            leadingString: "End Date:",
            selectedDate: endTime,
            onDateSelected: onEndTimeChanged,
          ),
        )
      ],
    );
  }
}
