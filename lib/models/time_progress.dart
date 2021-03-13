import 'package:meta/meta.dart';
import 'package:time_progress_tracker/models/app_exceptions.dart';
import 'package:time_progress_tracker/persistence/time_progress.dart';
import 'package:time_progress_tracker/uuid.dart';

@immutable
class TimeProgress {
  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;

  TimeProgress(this.name, this.startTime, this.endTime, {String id})
      : id = id ?? Uuid().generateV4();

  factory TimeProgress.initialDefault() {
    int thisYear = DateTime.now().year;
    return TimeProgress(
        "Initial Name", DateTime(thisYear - 1), DateTime(thisYear + 1));
  }

  factory TimeProgress.defaultFromDuration(Duration duration) =>
      TimeProgress("", DateTime.now(), DateTime.now().add(duration));

  TimeProgress copyWith(
          {String id, String name, DateTime startTime, DateTime endTime}) =>
      TimeProgress(
        name ?? this.name,
        startTime ?? this.startTime,
        endTime ?? this.endTime,
        id: id ?? this.id,
      );

  int daysBehind() => DateTime.now().difference(startTime).inDays;

  int daysLeft() => endTime.difference(DateTime.now()).inDays;

  int allDays() => endTime.difference(startTime).inDays;

  double percentDone() {
    double percent = this.daysBehind() / (this.allDays() / 100) / 100;
    if (percent < 0) percent = 0;
    if (percent > 1) percent = 1;
    return percent;
  }

  bool hasStarted() =>
      DateTime.now().millisecondsSinceEpoch > startTime.millisecondsSinceEpoch;

  int daysTillStart() {
    if (hasStarted()) throw new TimeProgressHasStartedException();
    return startTime.difference(DateTime.now()).inDays;
  }

  bool hasEnded() =>
      DateTime.now().millisecondsSinceEpoch > endTime.millisecondsSinceEpoch;

  int daysSinceEnd() {
    if (!hasEnded()) throw new TimeProgressHasNotEndedException();
    return DateTime.now().difference(endTime).inDays;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ startTime.hashCode ^ endTime.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeProgress &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          startTime == other.startTime &&
          endTime == other.endTime;

  @override
  String toString() =>
      "TimeProgress{id: $id, name: $name, startTime: $startTime, endTime: $endTime}";

  TimeProgressEntity toEntity() {
    if (!TimeProgress.isNameValid(name))
      throw new TimeProgressInvalidNameException(name);
    if (!TimeProgress.areTimesValid(startTime, endTime))
      throw new TimeProgressStartTimeIsNotBeforeEndTimeException(
          startTime, endTime);
    return TimeProgressEntity(id, name, startTime, endTime);
  }

  static TimeProgress fromEntity(TimeProgressEntity entity) =>
      TimeProgress(entity.name, entity.startTime, entity.endTime,
          id: entity.id ?? Uuid().generateV4());

  static bool isValid(TimeProgress tp) =>
      TimeProgress.isNameValid(tp.name) &&
      TimeProgress.areTimesValid(tp.startTime, tp.endTime);

  static bool isNameValid(String name) =>
      name != null && name != "" && name.length > 2 && name.length < 21;

  static bool areTimesValid(DateTime startTime, DateTime endTime) =>
      startTime.isBefore(endTime);
}
