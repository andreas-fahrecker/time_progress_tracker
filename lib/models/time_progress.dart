import 'package:meta/meta.dart';
import 'package:time_progress_calculator/persistence/time_progress_entity.dart';
import 'package:time_progress_calculator/uuid.dart';

@immutable
class TimeProgress {
  final String id;
  final DateTime startTime;
  final DateTime endTime;

  TimeProgress(this.startTime, this.endTime, {String id})
      : id = id ?? Uuid().generateV4();

  TimeProgress copyWith({String id, DateTime startTime, DateTime endTime}) {
    return TimeProgress(
      startTime ?? this.startTime,
      endTime ?? this.endTime,
      id: id ?? this.id,
    );
  }

  @override
  int get hashCode => id.hashCode ^ startTime.hashCode ^ endTime.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeProgress &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          startTime == other.startTime &&
          endTime == other.endTime;

  @override
  String toString() {
    return "Timer{id: $id, startTimer: $startTime, endTimer: $endTime}";
  }

  TimeProgressEntity toEntity() {
    return TimeProgressEntity(id, startTime, endTime);
  }

  static TimeProgress fromEntity(TimeProgressEntity entity) {
    return TimeProgress(
      entity.startTime,
      entity.endTime,
      id: entity.id ?? Uuid().generateV4(),
    );
  }
}
