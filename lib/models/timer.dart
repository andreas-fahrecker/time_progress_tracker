import 'package:meta/meta.dart';
import 'package:time_progress_calculator/persistence/timer_entity.dart';

@immutable
class Timer {
  final DateTime startTime;
  final DateTime endTime;

  Timer(this.startTime, this.endTime);

  Timer copyWith({DateTime startTime, DateTime endTime}) {
    return Timer(startTime ?? this.startTime, endTime ?? this.endTime);
  }

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Timer &&
          runtimeType == other.runtimeType &&
          startTime == other.startTime &&
          endTime == other.endTime;

  TimerEntity toEntity() {
    return TimerEntity(startTime, endTime);
  }

  static Timer fromEntity(TimerEntity entity) {
    return Timer(entity.startTime, entity.endTime);
  }
}
