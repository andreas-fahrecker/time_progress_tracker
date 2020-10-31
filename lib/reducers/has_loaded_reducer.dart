import 'package:redux/redux.dart';
import 'package:time_progress_calculator/actions/actions.dart';

final hasLoadedReducer = combineReducers<bool>([
  TypedReducer<bool, TimeProgressListLoadedAction>(_setLoaded),
  TypedReducer<bool, TimeProgressListNotLoadedAction>(_setUnloaded)
]);

bool _setLoaded(bool hasLoaded, TimeProgressListLoadedAction action) {
  return true;
}

bool _setUnloaded(bool hasLoaded, TimeProgressListNotLoadedAction action) {
  return false;
}
