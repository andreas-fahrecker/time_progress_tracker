import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_exceptions.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/date_picker_btn.dart';

class ProgressCreationScreen extends StatefulWidget {
  static const routeName = "/progress-creation";
  static const title = "Create Time Progress";

  @override
  State<StatefulWidget> createState() {
    return _ProgressCreationScreenState();
  }
}

class _ProgressCreationScreenState extends State<ProgressCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime pickedStartTime = DateTime.now();
  DateTime pickedEndTime = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);

  bool _validName = true;
  bool _validDates = true;

  void _createTimeProgress(BuildContext context) {
    try {
      TimeProgress tpToCreate =
          TimeProgress(_nameController.text, pickedStartTime, pickedEndTime);
      StoreProvider.of<AppState>(context)
          .dispatch(AddTimeProgressAction(tpToCreate));
      Navigator.pop(context);
    } on TimeProgressInvalidNameException catch (e) {
      setState(() {
        _validName = false;
      });
    } on TimeProgressStartTimeIsNotBeforeEndTimeException catch (e) {
      setState(() {
        _validDates = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(ProgressCreationScreen.title),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Progress Name",
                  errorText: _validName
                      ? null
                      : "The Name of the Time Progress has to be set.",
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: DatePickerBtn(
                      leadingString: "Start Date:",
                      pickedDate: pickedStartTime,
                      onDatePicked: (DateTime startTime) {
                        if (startTime != null) {
                          setState(() {
                            pickedStartTime = startTime;
                          });
                        }
                      },
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 5,
                    child: DatePickerBtn(
                      leadingString: "EndDate:",
                      pickedDate: pickedEndTime,
                      onDatePicked: (DateTime endTime) {
                        if (endTime != null) {
                          setState(() {
                            pickedEndTime = endTime;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            _validDates
                ? Spacer(
                    flex: 1,
                  )
                : Expanded(
                    child: Center(
                      child: Text(
                          "Your Picked Dates are invalid. The Start Date has to be before the end Date."),
                    ),
                  ),
            Spacer(
              flex: 4,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: <Widget>[
          Expanded(
            child: FloatingActionButton(
              heroTag: "createTimeProgressBTN",
              child: Icon(Icons.save),
              onPressed: () {
                _createTimeProgress(context);
              },
            ),
          ),
          Expanded(
            child: FloatingActionButton(
              heroTag: "cancelTimeProgressCreationBTN",
              child: Icon(Icons.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
