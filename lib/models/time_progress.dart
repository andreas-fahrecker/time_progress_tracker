import 'package:meta/meta.dart';
import 'package:time_progress_tracker/models/app_exceptions.dart';
import 'package:time_progress_tracker/persistence/time_progress_entity.dart';
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

  TimeProgress copyWith(
      {String id, String name, DateTime startTime, DateTime endTime}) {
    return TimeProgress(
      name ?? this.name,
      startTime ?? this.startTime,
      endTime ?? this.endTime,
      id: id ?? this.id,
    );
  }

  int daysBehind() {
    return DateTime.now().difference(startTime).inDays;
  }

  int daysLeft() {
    return endTime.difference(DateTime.now()).inDays;
  }

  int allDays() {
    return endTime.difference(startTime).inDays;
  }

  double percentDone() {
    double percent = this.daysBehind() / (this.allDays() / 100) / 100;
    if (percent < 0) percent = 0;
    if (percent > 1) percent = 1;
    return percent;
  }

  bool hasStarted() {
    return DateTime.now().millisecondsSinceEpoch >
        startTime.millisecondsSinceEpoch;
  }

  bool hasEnded() {
    return DateTime.now().millisecondsSinceEpoch >
        endTime.millisecondsSinceEpoch;
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
  String toString() {
    return "TimeProgress{id: $id, name: $name, startTime: $startTime, endTime: $endTime}";
  }

  TimeProgressEntity toEntity() {
    if (!TimeProgress.isNameValid(name))
      throw new TimeProgressInvalidNameException(name);
    if (!TimeProgress.areTimesValid(startTime, endTime))
      throw new TimeProgressStartTimeIsNotBeforeEndTimeException(
          startTime, endTime);
    return TimeProgressEntity(id, name, startTime, endTime);
  }

  static TimeProgress fromEntity(TimeProgressEntity entity) {
    return TimeProgress(
      entity.name,
      entity.startTime,
      entity.endTime,
      id: entity.id ?? Uuid().generateV4(),
    );
  }

  static bool isValid(TimeProgress tp) {
    return TimeProgress.isNameValid(tp.name) &&
        TimeProgress.areTimesValid(tp.startTime, tp.endTime);
  }

  static bool isNameValid(String name) {
    return name != null && name != "" && name.length > 2 && name.length < 21;
  }

  static bool areTimesValid(DateTime startTime, DateTime endTime) {
    return startTime.isBefore(endTime);
  }
}
