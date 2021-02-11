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
  final _nameTextController = TextEditingController();
  bool _validName = true, _validDate = true;

  void _onNameChanged() {
    if (TimeProgress.isNameValid(_nameTextController.text)) {
      widget.onTimeProgressChanged(
          widget.timeProgress.copyWith(name: _nameTextController.text));
      setState(() {
        _validName = true;
      });
    } else
      setState(() {
        _validName = false;
      });
  }

  void _onStartDateChanged(DateTime newStartDate) {
    if (TimeProgress.areTimesValid(newStartDate, widget.timeProgress.endTime)) {
      widget.onTimeProgressChanged(
          widget.timeProgress.copyWith(startTime: newStartDate));
      setState(() {
        _validDate = true;
      });
    } else
      setState(() {
        _validDate = false;
      });
  }

  void _onEndDateChanged(DateTime newEndDate) {
    if (TimeProgress.areTimesValid(widget.timeProgress.startTime, newEndDate)) {
      widget.onTimeProgressChanged(
          widget.timeProgress.copyWith(endTime: newEndDate));
      setState(() {
        _validDate = true;
      });
    } else
      setState(() {
        _validDate = false;
      });
  }

  @override
  void initState() {
    _nameTextController.text = widget.timeProgress.name;
    _nameTextController.addListener(_onNameChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [
      Expanded(
        child: TextField(
          controller: _nameTextController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Progress Name",
            errorText: _validName
                ? null
                : "The Name need to have at least 3 and at max 20 symbols.",
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
              "Invalid Dates. The Start Date has to be before the End Date",
              style: TextStyle(color: Colors.red),
            ),
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
