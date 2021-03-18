import 'package:meta/meta.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/time_progress.dart';
import 'package:time_progress_tracker/utils/constants.dart';

@immutable
class AppState {
  final bool hasProgressesLoaded, hasSettingsLoaded;
  final List<TimeProgress> timeProgressList;
  final AppSettings appSettings;

  AppState(
      {this.hasProgressesLoaded = false,
      this.hasSettingsLoaded = false,
      this.timeProgressList = const [],
      this.appSettings = defaultAppSettings});

  factory AppState.initial() =>
      AppState(hasProgressesLoaded: false, appSettings: defaultAppSettings);

  AppState copyWith({
    bool? hasLoaded,
    List<TimeProgress>? timeProgressList,
  }) {
    return AppState(
      hasProgressesLoaded: hasLoaded ?? this.hasProgressesLoaded,
      timeProgressList: timeProgressList ?? this.timeProgressList,
    );
  }

  @override
  int get hashCode => hasProgressesLoaded.hashCode ^ timeProgressList.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          hasProgressesLoaded == other.hasProgressesLoaded &&
          timeProgressList == other.timeProgressList;
}
