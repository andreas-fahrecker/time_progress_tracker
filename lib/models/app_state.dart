import 'package:meta/meta.dart';
import 'package:time_progress_tracker/models/app_settings.dart';
import 'package:time_progress_tracker/models/time_progress.dart';

@immutable
class AppState {
  final bool hasProgressesLoaded, hasSettingsLoaded;
  final List<TimeProgress> timeProgressList;
  final AppSettings appSettings;

  const AppState(
      {this.hasProgressesLoaded = false,
      this.hasSettingsLoaded = false,
      this.timeProgressList = const [],
      required this.appSettings});

  factory AppState.initial() =>
      AppState(hasProgressesLoaded: false, appSettings: AppSettings.defaults());

  AppState copyWith({
    bool? hasLoaded,
    List<TimeProgress>? timeProgressList,
    AppSettings? appSettings,
  }) {
    return AppState(
      hasProgressesLoaded: hasLoaded ?? hasProgressesLoaded,
      timeProgressList: timeProgressList ?? this.timeProgressList,
      appSettings: appSettings ?? this.appSettings,
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
