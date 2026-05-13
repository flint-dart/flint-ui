import 'navigation.dart';

class QueryParams {
  const QueryParams();

  Uri get _uri => currentUri;

  String? get(String key) {
    return _uri.queryParameters[key];
  }

  List<String> getAll(String key) {
    return _uri.queryParametersAll[key] ?? const [];
  }

  Map<String, String> get all {
    return Map.unmodifiable(_uri.queryParameters);
  }

  Map<String, List<String>> get allValues {
    return Map.unmodifiable(_uri.queryParametersAll);
  }

  bool has(String key) {
    return _uri.queryParameters.containsKey(key);
  }

  void set(
    String key,
    Object? value, {
    bool push = false,
    Object? state,
  }) {
    update(
      {
        key: value,
      },
      push: push,
      state: state,
    );
  }

  void update(
    Map<String, Object?> values, {
    bool push = false,
    Object? state,
  }) {
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

  void remove(String key, {bool push = false, Object? state}) {
    final next = Map<String, dynamic>.from(_uri.queryParameters)..remove(key);
    _write(next, push: push, state: state);
  }

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
