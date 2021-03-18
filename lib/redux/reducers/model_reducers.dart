import 'package:redux/redux.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/redux/actions/app_settings_actions.dart';
import 'package:time_progress_tracker/redux/actions/redux_actions.dart';
import 'package:time_progress_tracker/redux/actions/time_progress_actions.dart';
import 'package:time_progress_tracker/utils/constants.dart';

final timeProgressListReducer = combineReducers<List<TimeProgress>>([
  TypedReducer<List<TimeProgress>, TimeProgressListLoadedAction>(
      _setLoadedTimeProgressList),
  TypedReducer<List<TimeProgress>, TimeProgressListNotLoadedAction>(
      _setEmptyTimeProgressList),
  TypedReducer<List<TimeProgress>, AddTimeProgressAction>(_addTimeProgress),
  TypedReducer<List<TimeProgress>, UpdateTimeProgressAction>(
      _updateTimeProgress),
  TypedReducer<List<TimeProgress>, DeleteTimeProgressAction>(
      _deleteTimeProgress),
]);

List<TimeProgress> _setEmptyTimeProgressList(
    List<TimeProgress> timeProgressList,
    TimeProgressListNotLoadedAction action) {
  return [];
}

List<TimeProgress> _setLoadedTimeProgressList(
    List<TimeProgress> timeProgressList, TimeProgressListLoadedAction action) {
  return action.timeProgressList;
}

List<TimeProgress> _addTimeProgress(
        List<TimeProgress> timeProgressList, AddTimeProgressAction action) =>
    List.from(timeProgressList)
      ..add(action.timeProgress)
      ..toList(growable: false);

List<TimeProgress> _updateTimeProgress(
        List<TimeProgress> timeProgressList, UpdateTimeProgressAction action) =>
    timeProgressList
        .map((timeProgress) =>
            timeProgress.id == action.id ? action.timeProgress : timeProgress)
        .toList(growable: false);

List<TimeProgress> _deleteTimeProgress(
        List<TimeProgress> timeProgressList, DeleteTimeProgressAction action) =>
    timeProgressList
        .where((timeProgress) => timeProgress.id != action.id)
        .toList(growable: false);

final appSettingsReducers = combineReducers<AppSettings>([
  TypedReducer<AppSettings, AppSettingsLoadedActions>(_updateAppSettings),
  TypedReducer<AppSettings, UpdateAppSettingsActions>(_updateAppSettings),
  TypedReducer<AppSettings, AppSettingsNotLoadedAction>(_setDefaultSettings)
]);

AppSettings _setDefaultSettings(
        AppSettings appSettings, AppSettingsNotLoadedAction action) =>
    defaultAppSettings;

AppSettings _updateAppSettings(
        AppSettings appSettings, AppSettingsAction action) =>
    action.appSettings;
