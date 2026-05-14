import 'navigation.dart';

/// Represents the QueryParams API in Flint UI.
class QueryParams {
  /// Creates a QueryParams instance.
  const QueryParams();

  Uri get _uri => currentUri;

  /// Runs the get operation.
  String? get(String key) {
    return _uri.queryParameters[key];
  }

  /// Runs the getAll operation.
  List<String> getAll(String key) {
    return _uri.queryParametersAll[key] ?? const [];
  }

  /// Returns the all value.
  Map<String, String> get all {
    return Map.unmodifiable(_uri.queryParameters);
  }

  /// Returns the allValues value.
  Map<String, List<String>> get allValues {
    return Map.unmodifiable(_uri.queryParametersAll);
  }

  /// Runs the has operation.
  bool has(String key) {
    return _uri.queryParameters.containsKey(key);
  }

  /// Runs the set operation.
  void set(String key, Object? value, {bool push = false, Object? state}) {
    update({key: value}, push: push, state: state);
  }

  /// Runs the update operation.
  void update(Map<String, Object?> values, {bool push = false, Object? state}) {
    final next = Map<String, dynamic>.from(_uri.queryParameters);

    for (final entry in values.entries) {
      final value = entry.value;
      if (value == null) {
        next.remove(entry.key);
      } else if (value is Iterable) {
        next[entry.key] = value.map((item) => item.toString()).toList();
      } else {
        next[entry.key] = value.toString();
      }
    }

    _write(next, push: push, state: state);
  }

  /// Runs the remove operation.
  void remove(String key, {bool push = false, Object? state}) {
    final next = Map<String, dynamic>.from(_uri.queryParameters)..remove(key);
    _write(next, push: push, state: state);
  }

  /// Runs the clear operation.
  void clear({bool push = false, Object? state}) {
    _write(const {}, push: push, state: state);
  }

  void _write(
    Map<String, dynamic> values, {
    required bool push,
    Object? state,
  }) {
    final uri = _uri;
    final nextUri = values.isEmpty
        ? uri.replace(query: '')
        : uri.replace(queryParameters: values);
    final nextPath = nextUri.toString();

    if (push) {
      navigate(nextPath, state: state);
    } else {
      replace(nextPath, state: state);
    }
  }
}

const query = QueryParams();
