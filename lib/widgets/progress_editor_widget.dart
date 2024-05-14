import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/buttons/date_picker_btn.dart';

class ProgressEditorWidget extends StatefulWidget {
  final TimeProgress timeProgress;
  final Function(TimeProgress, bool) onTimeProgressChanged;

  const ProgressEditorWidget({
    super.key,
    required this.timeProgress,
    required this.onTimeProgressChanged,
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
    TimeProgress newProgress =
        widget.timeProgress.copyWith(name: _nameTextController.text);
    widget.onTimeProgressChanged(
        newProgress, TimeProgress.isValid(newProgress));
    setState(() {
      _validName = TimeProgress.isNameValid(newProgress.name);
    });
  }

  void _onStartDateChanged(DateTime? newStartDate) {
    if (newStartDate == null) {
      return;
    }
    TimeProgress newProgress =
        widget.timeProgress.copyWith(startTime: newStartDate);
    widget.onTimeProgressChanged(
        newProgress, TimeProgress.isValid(newProgress));
    setState(() {
      _validDate =
          TimeProgress.areTimesValid(newStartDate, newProgress.endTime);
    });
  }

  void _onEndDateChanged(DateTime? newEndDate) {
    if (newEndDate == null) {
      return;
    }
    TimeProgress newProgress =
        widget.timeProgress.copyWith(endTime: newEndDate);
    widget.onTimeProgressChanged(
        newProgress, TimeProgress.isValid(newProgress));
    setState(() {
      _validDate =
          TimeProgress.areTimesValid(newProgress.startTime, newEndDate);
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
    double heightFactor = (!_validDate) ? 0.3 : 0.5;

    List<Widget> columnChildren = [
      SizedBox(
        height: MediaQuery.of(context).size.height * heightFactor,
        child: TextField(
          controller: _nameTextController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "Progress Name",
            errorText: _validName
                ? null
                : "The Name need to have at least 3 and at max 20 symbols.",
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * heightFactor,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: DatePickerBtn(
                  leadingString: "Start Date:",
                  pickedDate: widget.timeProgress.startTime,
                  onDatePicked: _onStartDateChanged,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
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

    if (!_validDate) {
      columnChildren.add(
        SizedBox(
          height: MediaQuery.of(context).size.height * heightFactor,
          child: const Center(
            child: Text(
              "Invalid Dates. The Start Date has to be before the End Date",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: columnChildren,
      ),
    );
  }
}
