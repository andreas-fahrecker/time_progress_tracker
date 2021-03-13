import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class Repository<T> {
  final SharedPreferences prefs;
  final JsonCodec codec;

  Repository(this.prefs, {this.codec = json});

  Future<T> load();

  Future<bool> save(T e);
}
