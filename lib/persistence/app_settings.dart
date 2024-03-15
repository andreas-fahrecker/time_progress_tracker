import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_progress_tracker/models/app_settings.dart';

class AppSettingsRepository {
  static const String _key = "app_settings";
  final SharedPreferences prefs;
  final JsonCodec codec;

  AppSettingsRepository(this.prefs, {this.codec = json});

  Future<AppSettingsEntity> loadAppSettings() {
    final String? jsonString = prefs.getString(_key);
    if (jsonString == null) {
      return Future<AppSettingsEntity>.value(AppSettingsEntity.defaults());
    }
    return Future<AppSettingsEntity>.value(
        AppSettingsEntity.fromJson(codec.decode(jsonString)));
  }

  Future<bool> saveAppSettings(AppSettingsEntity appSettings) =>
      prefs.setString(_key, codec.encode(appSettings));
}

class AppSettingsEntity {
  static const String _doneKey = "doneColorValue",
      _leftKey = "leftColorValue",
      _durationDaysKey = "durationDays";
  final int doneColorValue, leftColorValue, durationDays;

  AppSettingsEntity(
      this.doneColorValue, this.leftColorValue, this.durationDays);

  factory AppSettingsEntity.defaults() => AppSettings.defaults().toEntity();

  @override
  int get hashCode => doneColorValue.hashCode ^ leftColorValue.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsEntity &&
          runtimeType == other.runtimeType &&
          doneColorValue == other.doneColorValue &&
          leftColorValue == other.leftColorValue;

  Map<String, Object> toJson() => {
        _doneKey: doneColorValue,
        _leftKey: leftColorValue,
        _durationDaysKey: durationDays,
      };

  static AppSettingsEntity fromJson(Map<String, Object> json) =>
      AppSettingsEntity(
        json[_doneKey] as int,
        json[_leftKey] as int,
        json[_durationDaysKey] as int,
      );
}
