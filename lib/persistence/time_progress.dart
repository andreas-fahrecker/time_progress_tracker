import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_progress_tracker/persistence/repository.dart';

class TimeProgressRepository extends Repository<List<TimeProgressEntity>> {
  static const String _key = "time_progress_repo";

  TimeProgressRepository(SharedPreferences prefs) : super(prefs);

  @override
  Future<List<TimeProgressEntity>> load() {
    final String jsonString = this.prefs.getString(_key);
    if (jsonString == null) {
      return Future<List<TimeProgressEntity>>.value([]);
    }
    return Future<List<TimeProgressEntity>>.value(codec
        .decode(jsonString)["timers"]
        .cast<Map<String, Object>>()
        .map<TimeProgressEntity>(TimeProgressEntity.fromJson)
        .toList(growable: false));
  }

  @override
  Future<bool> save(List<TimeProgressEntity> timeProgressList) {
    final String jsonString = codec.encode(
        {"timers": timeProgressList.map((timer) => timer.toJson()).toList()});
    return this.prefs.setString(_key, jsonString);
  }
}

class TimeProgressEntity {
  static const String _idKey = "id",
      _nameKey = "name",
      _startTimeKey = "startTime",
      _endTimeKey = "endTime";
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
      _idKey: id,
      _nameKey: name,
      _startTimeKey: startTime.millisecondsSinceEpoch,
      _endTimeKey: endTime.millisecondsSinceEpoch
    };
  }

  static TimeProgressEntity fromJson(Map<String, Object> json) {
    final String id = json[_idKey] as String;
    final String name = json[_nameKey] as String;
    final DateTime startTime =
        DateTime.fromMillisecondsSinceEpoch(json[_startTimeKey] as int);
    final DateTime endTime =
        DateTime.fromMillisecondsSinceEpoch(json[_endTimeKey] as int);
    return TimeProgressEntity(id, name, startTime, endTime);
  }
}
