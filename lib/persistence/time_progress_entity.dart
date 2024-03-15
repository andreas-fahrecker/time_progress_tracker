class TimeProgressEntity {
  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;

  TimeProgressEntity(this.id, this.name, this.startTime, this.endTime);

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ startTime.hashCode ^ endTime.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeProgressEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          startTime == other.startTime &&
          endTime == other.endTime;

  Map<String, Object> toJson() {
    return {
      "id": id,
      "name": name,
      "startTime": startTime.millisecondsSinceEpoch,
      "endTime": endTime.millisecondsSinceEpoch
    };
  }

  static TimeProgressEntity fromJson(dynamic json) {
    final String id = json["id"] as String;
    final String name = json["name"] as String;
    final DateTime startTime =
        DateTime.fromMillisecondsSinceEpoch(json["startTime"] as int);
    final DateTime endTime =
        DateTime.fromMillisecondsSinceEpoch(json["endTime"] as int);
    return TimeProgressEntity(id, name, startTime, endTime);
  }
}
