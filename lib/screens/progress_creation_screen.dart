import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/screens/progress_dashboard_screen.dart';
import 'package:time_progress_tracker/widgets/app_drawer_widget.dart';

class ProgressCreationScreen extends StatefulWidget {
  static const routeName = "/progress-creation";

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

  Future<DateTime> _selectDate(
      BuildContext context, DateTime initialDate) async {
    return await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
  }

  void _createTimeProgress(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(AddTimeProgressAction(
      TimeProgress(_nameController.text, pickedStartTime, pickedEndTime),
    ));
    Navigator.pushNamed(context, ProgressDashboardScreen.routeName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Progress"),
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Progress Name"),
              ),
            ),
            Expanded(
              child: Text("${_nameController.text}"),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: FlatButton(
                      color: Colors.blue,
                      child: Text(
                          "Start Date: ${pickedStartTime.toLocal().toString().split(" ")[0]}"),
                      onPressed: () async {
                        DateTime dt =
                            await _selectDate(context, pickedStartTime);
                        if (dt != null) {
                          setState(() {
                            pickedStartTime = dt;
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
                    child: FlatButton(
                      color: Colors.blue,
                      child: Text(
                          "End Date: ${pickedEndTime.toLocal().toString().split(" ")[0]}"),
                      onPressed: () async {
                        DateTime dt = await _selectDate(context, pickedEndTime);
                        if (dt != null) {
                          setState(() {
                            pickedEndTime = dt;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Spacer(
              flex: 5,
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
                Navigator.pushNamed(context, ProgressDashboardScreen.routeName);
              },
            ),
          )
        ],
      ),
    );
  }
}
