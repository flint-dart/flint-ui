import 'validation.dart';

typedef FlintVoidCallback = void Function();

class TextEditingController {
  TextEditingController({String text = ''}) : _text = text;

  String _text;
  final List<FlintVoidCallback> _listeners = [];

  String get text => _text;

  set text(String value) {
    if (_text == value) return;
    _text = value;
    _notifyListeners();
  }

  bool get isEmpty => _text.isEmpty;
  bool get isNotEmpty => _text.isNotEmpty;

  void clear() {
    text = '';
  }

  void addListener(FlintVoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(FlintVoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in List<FlintVoidCallback>.of(_listeners)) {
      listener();
    }
  }
}

FormController useForm(Map<String, Object?> initialValues) {
  return FormController(initialValues);
}

class FormController {
  FormController(Map<String, Object?> initialValues)
      : _defaults = Map<String, Object?>.from(initialValues),
        _data = Map<String, Object?>.from(initialValues);

  final Map<String, Object?> _defaults;
  final Map<String, Object?> _data;
  final Map<String, TextEditingController> _controllers = {};
  final List<FlintVoidCallback> _listeners = [];

  FormErrors errors = const FormErrors();
  bool processing = false;
  bool wasSuccessful = false;
  bool recentlySuccessful = false;

  Map<String, Object?> get data => Map<String, Object?>.unmodifiable(_data);

  Object? operator [](String key) => _data[key];

  String string(String key) => _data[key]?.toString() ?? '';

  TextEditingController controller(String key) {
    return _controllers.putIfAbsent(key, () {
      final controller = TextEditingController(text: string(key));
      controller.addListener(() {
        _data[key] = controller.text;
        _notifyListeners();
      });
      return controller;
    });
  }

  void setField(String key, Object? value) {
    _data[key] = value;
    final controller = _controllers[key];
    if (controller != null && controller.text != (value?.toString() ?? '')) {
      controller.text = value?.toString() ?? '';
      return;
    }
    _notifyListeners();
  }

  String? error(String key) => errors.field(key);

  void setError(String key, Object message) {
    errors = errors.merge(FormErrors.from({key: message}));
    _notifyListeners();
  }

  void setErrors(Object? messages) {
    errors = FormErrors.from(messages);
    _notifyListeners();
  }

  void clearErrors([List<String> keys = const []]) {
    if (keys.isEmpty) {
      errors = const FormErrors();
    } else {
      errors = errors.without(keys);
    }
    _notifyListeners();
  }

  void reset([List<String> keys = const []]) {
    final resetKeys = keys.isEmpty ? _defaults.keys : keys;
    for (final key in resetKeys) {
      setField(key, _defaults[key]);
    }
    clearErrors(keys.toList());
  }

  Future<T?> submit<T>(
    Future<T> Function(Map<String, Object?> data) action, {
    void Function(T result)? onSuccess,
    void Function(Object error)? onError,
    void Function(FormErrors errors)? onValidationError,
    bool resetOnSuccess = false,
  }) async {
    processing = true;
    wasSuccessful = false;
    recentlySuccessful = false;
    clearErrors();

    try {
      final result = await action(data);
      wasSuccessful = true;
      recentlySuccessful = true;
      if (resetOnSuccess) reset();
      onSuccess?.call(result);
      return result;
    } catch (error) {
      final validationErrors = FormErrors.from(error);
      if (validationErrors.isNotEmpty) {
        errors = validationErrors;
        onValidationError?.call(validationErrors);
      }
      onError?.call(error);
      return null;
    } finally {
      processing = false;
      _notifyListeners();
    }
  }

  void addListener(FlintVoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(FlintVoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in List<FlintVoidCallback>.of(_listeners)) {
      listener();
    }
  }
}
