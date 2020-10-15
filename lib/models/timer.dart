import 'package:meta/meta.dart';
import 'package:time_progress_calculator/persistence/timer_entity.dart';
import 'package:time_progress_calculator/uuid.dart';

@immutable
class Timer {
  final String id;
  final DateTime startTime;
  final DateTime endTime;

  Timer(this.startTime, this.endTime, {String id})
      : id = id ?? Uuid().generateV4();

  Timer copyWith({String id, DateTime startTime, DateTime endTime}) {
    return Timer(
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
      other is Timer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          startTime == other.startTime &&
          endTime == other.endTime;

  @override
  String toString() {
    return "Timer{id: $id, startTimer: $startTime, endTimer: $endTime}";
  }

  TimerEntity toEntity() {
    return TimerEntity(id, startTime, endTime);
  }

  static Timer fromEntity(TimerEntity entity) {
    return Timer(
      entity.startTime,
      entity.endTime,
      id: entity.id ?? Uuid().generateV4(),
    );
  }
}
