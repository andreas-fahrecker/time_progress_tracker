class TimeProgressEntity {
  final String id;
  final DateTime startTime;
  final DateTime endTime;

  TimeProgressEntity(this.id, this.startTime, this.endTime);

  @override
  int get hashCode => id.hashCode ^ startTime.hashCode ^ endTime.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeProgressEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          startTime == other.startTime &&
          endTime == other.endTime;

  Map<String, Object> toJson() {
    return {
      "id": id,
      "startTime": startTime.millisecondsSinceEpoch,
      "endTime": startTime.millisecondsSinceEpoch
    };
  }

  static TimeProgressEntity fromJson(Map<String, Object> json) {
    final String id = json["id"] as String;
    final DateTime startTime =
        DateTime.fromMillisecondsSinceEpoch(json["startTime"] as int);
    final DateTime endTime =
        DateTime.fromMillisecondsSinceEpoch(json["endTime"] as int);
    return TimeProgressEntity(id, startTime, endTime);
  }
}
