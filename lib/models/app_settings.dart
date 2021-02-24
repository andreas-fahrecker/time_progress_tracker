import 'package:flutter/material.dart';
import 'package:time_progress_tracker/persistence/app_settings.dart';

@immutable
class AppSettings {
  final Color doneColor;
  final Color leftColor;

  AppSettings({
    this.doneColor,
    this.leftColor,
  });

  factory AppSettings.defaults() =>
      AppSettings(doneColor: Colors.green, leftColor: Colors.red);

  AppSettings copyWith({
    Color doneColor,
    Color leftColor,
  }) =>
      AppSettings(
          doneColor: doneColor ?? this.doneColor,
          leftColor: leftColor ?? this.leftColor);

  @override
  int get hashCode => doneColor.hashCode ^ leftColor.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          doneColor == other.doneColor &&
          leftColor == other.leftColor;

  AppSettingsEntity toEntity() =>
      AppSettingsEntity(doneColor.value, leftColor.value);

  static AppSettings fromEntity(AppSettingsEntity entity) => AppSettings(
      doneColor: Color(entity.doneColorValue),
      leftColor: Color(entity.leftColorValue));
}
