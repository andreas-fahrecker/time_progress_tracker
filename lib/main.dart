import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Progress Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Time Progress Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _startDateKey = "startDate";
  final String _endDateKey = "endDate";
  DateTime startDate = DateTime(2000);
  DateTime endDate = DateTime(2100);

  void _retrieveDates() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      startDate = DateTime.fromMillisecondsSinceEpoch(
          prefs.getInt(_startDateKey) ?? DateTime(2000).millisecondsSinceEpoch);
      endDate = DateTime.fromMillisecondsSinceEpoch(
          prefs.getInt(_endDateKey) ?? DateTime(2100).millisecondsSinceEpoch);
    });
  }

  void _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != startDate) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(_startDateKey, picked.millisecondsSinceEpoch);
      setState(() {
        startDate = picked;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != endDate) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(_endDateKey, picked.millisecondsSinceEpoch);
      setState(() {
        endDate = picked;
      });
    }
  }

  int _getAmountOfDaysDone() {
    return DateTime.now().difference(startDate).inDays;
  }

  int _getAmountOfDaysLeft() {
    return endDate.difference(DateTime.now()).inDays;
  }

  int _getAmountOfAllDays() {
    return endDate.difference(startDate).inDays;
  }

  double _getPercent() {
    final int wholeDuration = _getAmountOfAllDays();
    final int currentDuration = _getAmountOfDaysDone();
    final double onePercent = wholeDuration / 100;
    return currentDuration / onePercent / 100;
  }

  @override
  void initState() {
    super.initState();
    _retrieveDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Start Date:",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("${startDate.toLocal()}".split(" ")[0]),
                  ),
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      onPressed: () => _selectStartDate(context),
                      child: Text("Change"),
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  Spacer(flex: 1)
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      "End Date:",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("${endDate.toLocal()}".split(" ")[0]),
                  ),
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      onPressed: () => _selectEndDate(context),
                      child: Text("Change"),
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  Spacer(flex: 1)
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: CircularPercentIndicator(
                radius: 100,
                lineWidth: 10,
                percent: _getPercent(),
                progressColor: Colors.green,
                backgroundColor: Colors.red,
                center: Text("${(_getPercent() * 100).floor()} %"),
              ),
            ),
            Expanded(
              flex: 1,
              child: LinearPercentIndicator(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                percent: _getPercent(),
                leading: Text("${_getAmountOfDaysDone()} Days"),
                center: Text("${(_getPercent() * 100).floor()} %"),
                trailing: Text("${_getAmountOfDaysLeft()} Days"),
                progressColor: Colors.green,
                backgroundColor: Colors.red,
                lineHeight: 25,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text("${_getAmountOfAllDays()} Days"),
            ),
          ],
        ),
      ),
    );
  }
}
