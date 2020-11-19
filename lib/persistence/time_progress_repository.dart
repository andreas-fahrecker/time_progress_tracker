import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_progress_tracker/persistence/time_progress_entity.dart';

class TimeProgressRepository {
  static const String _key = "time_progress_repo";
  final SharedPreferences prefs;
  final JsonCodec codec;

  TimeProgressRepository(this.prefs, {this.codec = json});

  Future<List<TimeProgressEntity>> loadTimeProgressList() {
    final String jsonString = this.prefs.getString(_key);
    return Future<List<TimeProgressEntity>>.value(codec
        .decode(jsonString)["timers"]
        .cast<Map<String, Object>>()
        .map<TimeProgressEntity>(TimeProgressEntity.fromJson)
        .toList(growable: false));
  }

  Future<bool> saveTimeProgressList(List<TimeProgressEntity> timeProgressList) {
    final String jsonString = codec.encode(
        {"timers": timeProgressList.map((timer) => timer.toJson()).toList()});
    return this.prefs.setString(_key, jsonString);
  }
}
