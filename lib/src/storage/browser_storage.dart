import 'dart:convert';

import 'package:universal_web/web.dart' as web;

/// Represents the BrowserStorage API in Flint UI.
abstract class BrowserStorage {
  /// Creates a BrowserStorage instance.
  const BrowserStorage();

  web.Storage get storage;

  /// Runs the read operation.
  String? read(String key) {
    return storage.getItem(key);
  }

  /// Runs the write operation.
  void write(String key, String value) {
    storage.setItem(key, value);
  }

  /// Runs the has operation.
  bool has(String key) {
    return read(key) != null;
  }

  Object? readJson(String key) {
    final value = read(key);
    if (value == null || value.isEmpty) return null;
    return jsonDecode(value);
  }

  /// Runs the readMap operation.
  Map<String, dynamic> readMap(String key) {
    final decoded = readJson(key);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry(key.toString(), value));
    }
    return const {};
  }

  /// Runs the writeJson operation.
  void writeJson(String key, Object? value) {
    write(key, jsonEncode(value));
  }

  /// Runs the remove operation.
  String? remove(String key) {
    final value = read(key);
    storage.removeItem(key);
    return value;
  }

  /// Runs the clear operation.
  void clear() {
    storage.clear();
  }
}
