/// Represents the FormErrors API in Flint UI.
class FormErrors {
  final Map<String, List<String>> _messages;

  /// Creates a FormErrors instance.
  const FormErrors([Map<String, List<String>> messages = const {}])
    : _messages = messages;

  /// Creates a FormErrors instance.
  factory FormErrors.from(Object? value) {
    if (value == null) return const FormErrors();
    if (value is FormErrors) return value;
    if (value is Map<String, String>) {
      return FormErrors({
        for (final entry in value.entries) entry.key: [entry.value],
      });
    }
    if (value is Map) {
      final source = _extractErrorMap(value);
      return FormErrors({
        for (final entry in source.entries)
          entry.key.toString(): _normalizeMessages(entry.value),
      });
    }

    return const FormErrors();
  }

  /// Creates a FormErrors instance.
  factory FormErrors.fromJson(Map<String, Object?> json) {
    return FormErrors.from(json);
  }

  /// Returns the messages value.
  Map<String, List<String>> get messages => Map.unmodifiable(_messages);

  /// Returns the isEmpty value.
  bool get isEmpty => _messages.isEmpty;

  /// Returns the isNotEmpty value.
  bool get isNotEmpty => _messages.isNotEmpty;

  /// Runs the fieldMessages operation.
  List<String> fieldMessages(String? name) {
    if (name == null || name.isEmpty) return const [];
    return List.unmodifiable(_messages[name] ?? const []);
  }

  /// Runs the field operation.
  String? field(String? name) {
    final messages = fieldMessages(name);
    return messages.isEmpty ? null : messages.first;
  }

  /// Runs the has operation.
  bool has(String? name) => fieldMessages(name).isNotEmpty;

  FormErrors merge(FormErrors other) {
    if (other.isEmpty) return this;
    if (isEmpty) return other;

    return FormErrors({
      ..._messages,
      for (final entry in other._messages.entries)
        entry.key: [...(_messages[entry.key] ?? const []), ...entry.value],
    });
  }

  FormErrors without([List<String> keys = const []]) {
    if (keys.isEmpty) return const FormErrors();
    return FormErrors(
      {..._messages}..removeWhere((key, _) => keys.contains(key)),
    );
  }

  /// Returns the firstMessages value.
  Map<String, String> get firstMessages => {
    for (final entry in _messages.entries)
      if (entry.value.isNotEmpty) entry.key: entry.value.first,
  };

  /// Runs the toJson operation.
  Map<String, Object?> toJson() => {
    for (final entry in _messages.entries) entry.key: entry.value,
  };
}

String? resolveFieldError({
  required String? name,
  String? error,
  FormErrors? errors,
}) {
  /// Creates a if instance.
  if (error != null && error.isNotEmpty) return error;
  return errors?.field(name);
}

Map _extractErrorMap(Map value) {
  final nested = value['errors'];

  /// Creates a if instance.
  if (nested is Map) return nested;
  return value;
}

List<String> _normalizeMessages(Object? value) {
  /// Creates a if instance.
  if (value == null) return const [];

  /// Creates a if instance.
  if (value is String) return [value];

  /// Creates a if instance.
  if (value is Iterable) {
    return [
      for (final item in value)
        if (item != null && item.toString().isNotEmpty) item.toString(),
    ];
  }
  return [value.toString()];
}
