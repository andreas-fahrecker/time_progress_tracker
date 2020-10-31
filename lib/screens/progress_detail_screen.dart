import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_calculator/actions/actions.dart';
import 'package:time_progress_calculator/models/app_state.dart';
import 'package:time_progress_calculator/models/time_progress.dart';
import 'package:time_progress_calculator/screens/progress_dashboard_screen.dart';
import 'package:time_progress_calculator/selectors/time_progress_selectors.dart';
import 'package:time_progress_calculator/widgets/app_drawer_widget.dart';
import 'package:time_progress_calculator/widgets/progress_detail_widgets/progress_detail_circular_percent_widget.dart';
import 'package:time_progress_calculator/widgets/progress_detail_widgets/progress_detail_edit_dates_row_widget.dart';
import 'package:time_progress_calculator/widgets/progress_detail_widgets/progress_detail_fab_editing_row_widget.dart';
import 'package:time_progress_calculator/widgets/progress_detail_widgets/progress_detail_fab_row_widget.dart';
import 'package:time_progress_calculator/widgets/progress_detail_widgets/progress_detail_linear_percent_widget.dart';
import 'package:time_progress_calculator/widgets/progress_detail_widgets/progress_detail_select_date_btn_widget.dart';

class ProgressDetailScreenArguments {
  final String id;

  ProgressDetailScreenArguments(this.id);
}

class ProgressDetailScreen extends StatefulWidget {
  static const routeName = "/progress-detail";

  @override
  State<StatefulWidget> createState() {
    return _ProgressDetailScreenState();
  }
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isBeingEdited = false;
  TimeProgress _editedProgress = TimeProgress(
      "Default Name", DateTime.now(), DateTime(DateTime.now().year + 1));

  void _onStartDateChanged(DateTime picked) {
    if (picked != null) {
      setState(() {
        _editedProgress = _editedProgress.copyWith(startTime: picked);
      });
    }
  }

  void _onEndDateChanged(DateTime picked) {
    if (picked != null) {
      setState(() {
        _editedProgress = _editedProgress.copyWith(endTime: picked);
      });
    }
  }

  void _onSaveTimeProgress(Store<AppState> store, id) {
    store.dispatch(UpdateTimeProgressAction(id, _editedProgress));
    setState(() {
      _isBeingEdited = false;
    });
  }

  void _onCancelEditTimeProgress() {
    setState(() {
      _isBeingEdited = false;
    });
  }

  void _onEditTimeProgress(Store<AppState> store, id) {
    setState(() {
      _isBeingEdited = true;
      _editedProgress = timeProgressByIdSelector(store.state, id);
      _nameController.text = _editedProgress.name;
    });
  }

  void _onDeleteTimeProgress(Store<AppState> store, id) {
    store.dispatch(DeleteTimeProgressAction(id));
    Navigator.pushNamed(context, ProgressDashboardScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      this.setState(() {
        this._editedProgress =
            this._editedProgress.copyWith(name: _nameController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDetailScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    final Store<AppState> store = StoreProvider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Progress"),
      ),
      drawer: AppDrawer(),
      body: Container(
        margin: EdgeInsets.all(8),
        child: StoreConnector(
          converter: (Store<AppState> store) =>
              _ViewModel.fromStoreAndArg(store, args),
          onInit: (Store<AppState> store) {
            if (!store.state.hasLoaded) {
              store.dispatch(LoadTimeProgressListAction());
            }
          },
          builder: (BuildContext context, _ViewModel vm) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: _isBeingEdited
                      ? TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Progress Name"),
                        )
                      : FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            vm.timeProgress.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                ),
                Expanded(
                  flex: 2,
                  child: ProgressDetailCircularPercent(
                    percentDone: _isBeingEdited
                        ? _editedProgress.percentDone()
                        : vm.timeProgress.percentDone(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ProgressDetailLinearPercent(
                    timeProgress:
                        _isBeingEdited ? _editedProgress : vm.timeProgress,
                  ),
                ),
                this._isBeingEdited
                    ? Expanded(
                        flex: 1,
                        child: ProgressDetailEditDatesRow(
                          startTime: _editedProgress.startTime,
                          endTime: _editedProgress.endTime,
                          onStartTimeChanged: _onStartDateChanged,
                          onEndTimeChanged: _onEndDateChanged,
                        ),
                      )
                    : Spacer(flex: 1),
                Spacer(
                  flex: 1,
                )
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isBeingEdited
          ? ProgressDetailFabEditingRow(
              onSave: () => _onSaveTimeProgress(store, args.id),
              onCancelEdit: _onCancelEditTimeProgress,
            )
          : ProgressDetailFabRow(
              onEdit: () => _onEditTimeProgress(store, args.id),
              onDelete: () => _onDeleteTimeProgress(store, args.id),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

class _ViewModel {
  final TimeProgress timeProgress;

  _ViewModel({
    @required this.timeProgress,
  });

  static _ViewModel fromStoreAndArg(
      Store<AppState> store, ProgressDetailScreenArguments args) {
    return _ViewModel(
      timeProgress: timeProgressByIdSelector(store.state, args.id),
    );
  }
}
