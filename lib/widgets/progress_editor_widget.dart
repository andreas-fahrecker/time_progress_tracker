import 'package:flutter/material.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/date_picker_btn.dart';

class ProgressEditorWidget extends StatefulWidget {
  final TimeProgress timeProgress;
  final Function(TimeProgress) onTimeProgressChanged;

  ProgressEditorWidget({
    @required this.timeProgress,
    @required this.onTimeProgressChanged,
  });

  @override
  State<StatefulWidget> createState() {
    return _ProgressEditorWidgetState();
  }
}

class _ProgressEditorWidgetState extends State<ProgressEditorWidget> {
  bool _validName = true, _validDate = true;

  void _onNameChanged(String newName) {
    if (!TimeProgress.isNameValid(newName))
      setState(() {
        _validName = false;
      });

    widget.onTimeProgressChanged(widget.timeProgress.copyWith(name: newName));
    setState(() {
      _validName = true;
    });
  }

  void _onStartDateChanged(DateTime newStartDate) {
    if (!TimeProgress.areTimesValid(newStartDate, widget.timeProgress.endTime))
      setState(() {
        _validDate = false;
      });

    widget.onTimeProgressChanged(
        widget.timeProgress.copyWith(startTime: newStartDate));
    setState(() {
      _validDate = true;
    });
  }

  void _onEndDateChanged(DateTime newEndDate) {
    if (!TimeProgress.areTimesValid(widget.timeProgress.startTime, newEndDate))
      setState(() {
        _validDate = false;
      });

    widget.onTimeProgressChanged(
        widget.timeProgress.copyWith(endTime: newEndDate));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [
      Expanded(
        child: TextField(
          onChanged: _onNameChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Progress Name",
            errorText:
                _validName ? null : "The Name of the Progress can't be empty.",
          ),
        ),
      ),
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: DatePickerBtn(
                  leadingString: "Start Date:",
                  pickedDate: widget.timeProgress.startTime,
                  onDatePicked: _onStartDateChanged,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: DatePickerBtn(
                  leadingString: "End Date:",
                  pickedDate: widget.timeProgress.endTime,
                  onDatePicked: _onEndDateChanged,
                ),
              ),
            ),
          ],
        ),
      )
    ];

    if (!_validDate)
      columnChildren.add(
        Expanded(
          child: Center(
            child: Text(
                "Invalid Dates. The Start Date has to be before the End Date"),
          ),
        ),
      );

    return Container(
      child: Column(
        children: columnChildren,
      ),
    );
  }
}
