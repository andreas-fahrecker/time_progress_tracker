import 'package:meta/meta.dart';
import 'package:time_progress_calculator/persistence/time_progress_entity.dart';
import 'package:time_progress_calculator/uuid.dart';

@immutable
class TimeProgress {
  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;

  TimeProgress(this.name, this.startTime, this.endTime, {String id})
      : id = id ?? Uuid().generateV4();

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
    return this.daysBehind() / (this.allDays() / 100) / 100;
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
}
