import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_progress_calculator/persistence/timer_entity.dart';

class TimersRepository {
  static const String _key = "timers_repo";
  final SharedPreferences prefs;
  final JsonCodec codec;

  TimersRepository(this.prefs, {this.codec = json});

  Future<List<TimerEntity>> loadTimers() {
    final String jsonString = this.prefs.getString(_key);
    return codec
        .decode(jsonString)["timers"]
        .cast<Map<String, Object>>()
        .map<TimerEntity>(TimerEntity.fromJson)
        .toList(growable: false);
  }

  Future<bool> saveTimers(List<TimerEntity> timers) {
    final String jsonString = codec
        .encode({"timers": timers.map((timer) => timer.toJson()).toList()});
    return this.prefs.setString(_key, jsonString);
  }
}
