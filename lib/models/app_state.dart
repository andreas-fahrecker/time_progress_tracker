import 'package:meta/meta.dart';
import 'package:time_progress_calculator/models/time_progress.dart';

@immutable
class AppState {
  final bool hasLoaded;
  final List<TimeProgress> timeProgressList;

  AppState({
    this.hasLoaded = false,
    this.timeProgressList = const [],
  });

  factory AppState.initial() => AppState(hasLoaded: false);

  AppState copyWith({
    bool hasLoaded,
    List<TimeProgress> timeProgressList,
  }) {
    return AppState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      timeProgressList: timeProgressList ?? this.timeProgressList,
    );
  }

  @override
  int get hashCode => hasLoaded.hashCode ^ timeProgressList.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          hasLoaded == other.hasLoaded &&
          timeProgressList == other.timeProgressList;
}
