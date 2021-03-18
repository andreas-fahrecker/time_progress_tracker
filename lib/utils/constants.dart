import 'package:flutter/material.dart';
import 'package:time_progress_tracker/models/app_settings.dart';

const txtActiveProgressesScreen = "Active Progresses";
const txtInactiveProgressesScreen = "Inactive Progresses";
const txtSettingsScreen = "Settings";
const defaultAppSettings = AppSettings(
  doneColor: Colors.green,
  leftColor: Colors.red,
  duration: Duration(days: 365),
);