class TimerEntity {
  final DateTime startTime;
  final DateTime endTime;

  TimerEntity(this.startTime, this.endTime);

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerEntity &&
          runtimeType == other.runtimeType &&
          startTime == other.startTime &&
          endTime == other.endTime;

  Map<String, Object> toJson() {
    return {
      "startTime": startTime.millisecondsSinceEpoch,
      "endTime": startTime.millisecondsSinceEpoch
    };
  }

  static TimerEntity fromJson(Map<String, Object> json) {
    DateTime startTime =
        DateTime.fromMillisecondsSinceEpoch(json["startTime"] as int);
    DateTime endTime =
        DateTime.fromMillisecondsSinceEpoch(json["endTime"] as int);
    return TimerEntity(startTime, endTime);
  }
}
