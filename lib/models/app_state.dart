import 'package:meta/meta.dart';
import 'package:time_progress_calculator/models/timer.dart';

@immutable
class AppState {
  final Timer timer;

  AppState({this.timer});

  AppState copyWith({Timer timer}) {
    return AppState(timer: timer ?? this.timer);
  }

  @override
  int get hashCode => timer.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          timer == other.timer;
}
