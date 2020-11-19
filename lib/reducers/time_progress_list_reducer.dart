import 'package:redux/redux.dart';
import 'package:time_progress_tracker/actions/actions.dart';
import 'package:time_progress_tracker/models/time_progress.dart';

import 'dart:developer' as developer;

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
  developer.log("Time Progress Not Loaded Action");
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
