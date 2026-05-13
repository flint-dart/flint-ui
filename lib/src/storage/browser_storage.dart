import 'dart:convert';

import 'package:universal_web/web.dart' as web;

abstract class BrowserStorage {
  const BrowserStorage();

  web.Storage get storage;

  String? read(String key) {
    return storage.getItem(key);
  }

  void write(String key, String value) {
    storage.setItem(key, value);
  }

  bool has(String key) {
    return read(key) != null;
  }

  Object? readJson(String key) {
    final value = read(key);
    if (value == null || value.isEmpty) return null;
    return jsonDecode(value);
  }

  Map<String, dynamic> readMap(String key) {
    final decoded = readJson(key);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry(key.toString(), value));
    }
    return const {};
  }

  void writeJson(String key, Object? value) {
    write(key, jsonEncode(value));
  }

  String? remove(String key) {
    final value = read(key);
    storage.removeItem(key);
    return value;
  }

  void clear() {
    storage.clear();
  }
}
