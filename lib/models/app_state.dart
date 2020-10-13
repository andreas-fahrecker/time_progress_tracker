import 'package:meta/meta.dart';
import 'package:time_progress_calculator/models/timer.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<Timer> timers;

  AppState({
    this.isLoading = false,
    this.timers = const [],
  });

  factory AppState.initial() => AppState(isLoading: true);

  AppState copyWith({
    bool isLoading,
    List<Timer> timers,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      timers: timers ?? this.timers,
    );
  }

  @override
  int get hashCode => timers.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          timers == other.timers;
}
