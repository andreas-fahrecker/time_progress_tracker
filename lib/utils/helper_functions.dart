import 'dart:ui';

import 'package:redux/redux.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/redux/actions/app_settings_actions.dart';
import 'package:time_progress_tracker/redux/actions/time_progress_actions.dart';
import 'package:time_progress_tracker/redux/app_state.dart';

void loadTimeProgressListIfUnloaded(Store<AppState> store) {
  if (!store.state.hasProgressesLoaded)
    store.dispatch(LoadTimeProgressListAction());
}

void loadSettingsIfUnloaded(Store<AppState> store) {
  if (!store.state.hasSettingsLoaded) store.dispatch(LoadAppSettingsAction());
}

TimeProgress selectProgressById(List<TimeProgress> tpList, String id) =>
    tpList.firstWhere((tp) => tp.id == id, orElse: null);

List<TimeProgress> selectActiveProgresses(List<TimeProgress> tpList) =>
    tpList.where((tp) => tp.hasStarted() && !tp.hasEnded()).toList();

List<TimeProgress> selectInactiveProgresses(List<TimeProgress> tpList) =>
    tpList.where((tp) => !tp.hasStarted() || tp.hasEnded()).toList();

bool useBrightBackground(Color bC) {
  double yiq = ((bC.red * 299) + (bC.green * 587) + (bC.blue * 114)) / 1000;
  return yiq >= 186 || (bC.red == 0 && bC.green == 0 && bC.blue == 0);
}