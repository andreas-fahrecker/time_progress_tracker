import 'package:time_progress_calculator/actions/actions.dart';
import 'package:time_progress_calculator/models/time_progress.dart';
import 'package:redux/redux.dart';

final timeProgressListReducer = combineReducers<List<TimeProgress>>([
  TypedReducer<List<TimeProgress>, TimeProgressListLoadedAction>(
      _setLoadedTimeProgressList),
  TypedReducer<List<TimeProgress>, TimeProgressListNotLoadedAction>(
      _setEmptyTimeProgressList),
  TypedReducer<List<TimeProgress>, AddTimeProgressAction>(_addTimeProgress),
  TypedReducer<List<TimeProgress>, UpdateTimeProgressAction>(
      _updateTimeProgress),
  TypedReducer<List<TimeProgress>, DeleteTimeProgressAction>(_deleteTimeProgress),
]);

List<TimeProgress> _setLoadedTimeProgressList(
    List<TimeProgress> timeProgressList, TimeProgressListLoadedAction action) {
  return action.timeProgressList;
}

List<TimeProgress> _setEmptyTimeProgressList(
    List<TimeProgress> timeProgressList, TimeProgressListNotLoadedAction action) {
  return [];
}

List<TimeProgress> _addTimeProgress(
    List<TimeProgress> timeProgressList, AddTimeProgressAction action) {
  return List.from(timeProgressList)
    ..add(action.timeProgress)
    ..toList(growable: false);
}

List<TimeProgress> _updateTimeProgress(
    List<TimeProgress> timeProgressList, UpdateTimeProgressAction action) {
  return timeProgressList
      .map((timeProgress) => timeProgress.id == action.id
          ? action.updatedTimeProgress
          : timeProgress)
      .toList(growable: false);
}

List<TimeProgress> _deleteTimeProgress(
    List<TimeProgress> timeProgressList, DeleteTimeProgressAction action) {
  return timeProgressList.where((timeProgress) => timeProgress.id != action.id).toList(growable: false);
}