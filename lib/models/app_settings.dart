import 'package:flutter/material.dart';
import 'package:time_progress_tracker/persistence/app_settings.dart';

@immutable
class AppSettings {
  final Color doneColor;
  final Color leftColor;
  final Duration duration;

  const AppSettings({
    required this.doneColor,
    required this.leftColor,
    required this.duration,
  });

  AppSettings copyWith({
    Color? doneColor,
    Color? leftColor,
    Duration? duration,
  }) =>
      AppSettings(
        doneColor: doneColor ?? this.doneColor,
        leftColor: leftColor ?? this.leftColor,
        duration: duration ?? this.duration,
      );

  @override
  int get hashCode =>
      doneColor.hashCode ^ leftColor.hashCode ^ duration.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          doneColor == other.doneColor &&
          leftColor == other.leftColor &&
          duration == other.duration;

  AppSettingsEntity toEntity() =>
      AppSettingsEntity(doneColor.value, leftColor.value, duration.inDays);

  static AppSettings fromEntity(AppSettingsEntity entity) => AppSettings(
        doneColor: Color(entity.doneColorValue),
        leftColor: Color(entity.leftColorValue),
        duration: Duration(days: entity.durationDays),
      );
}
