import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/widgets/progress_editor_widget.dart';

class ProgressCreationScreen extends StatefulWidget {
  static const routeName = "/create-progress";
  static const title = "Create Time Progress";

  @override
  State<StatefulWidget> createState() {
    return _ProgressCreationScreenState();
  }
}

class _ProgressCreationScreenState extends State<ProgressCreationScreen> {
  TimeProgress timeProgressToCreate =
      TimeProgress("", DateTime.now(), DateTime(DateTime.now().year + 1));

  void onTimeProgressChanged(TimeProgress newTimeProgress) {
    setState(() {
      timeProgressToCreate = newTimeProgress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProgressCreationScreen.title),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: ProgressEditorWidget(
          timeProgress: timeProgressToCreate,
          onTimeProgressChanged: onTimeProgressChanged,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: <Widget>[
          Expanded(
            child: FloatingActionButton(
              heroTag: "createTimeProgressBTN",
              child: Icon(Icons.save),
              onPressed: TimeProgress.isValid(timeProgressToCreate)
                  ? () {
                      StoreProvider.of<AppState>(context).dispatch(
                          AddTimeProgressAction(timeProgressToCreate));
                      Navigator.pop(context);
                    }
                  : null,
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
