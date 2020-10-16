import 'package:meta/meta.dart';
import 'package:time_progress_calculator/models/time_progress.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<TimeProgress> timeProgressList;

  AppState({
    this.isLoading = false,
    this.timeProgressList = const [],
  });

  factory AppState.initial() => AppState(isLoading: true);

  AppState copyWith({
    bool isLoading,
    List<TimeProgress> timeProgressList,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      timeProgressList: timeProgressList ?? this.timeProgressList,
    );
  }

  @override
  int get hashCode => timeProgressList.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          timeProgressList == other.timeProgressList;
}
