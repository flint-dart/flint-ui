import 'package:flint_client/flint_client.dart';
import 'package:universal_web/web.dart' as web;

/// Represents the ClientRouter API in Flint UI.
class ClientRouter {
  /// Creates a ClientRouter instance.
  ClientRouter({
    String? baseUrl,
    this.prefix = '',
    Map<String, String> headers = const {},
    Map<String, dynamic> query = const {},
    Duration timeout = const Duration(seconds: 30),
    bool debug = false,
    bool throwIfError = false,
    ErrorHandler? onError,
    RequestDoneCallback? onDone,
    StatusCodeConfig statusCodeConfig = const StatusCodeConfig(),
  }) : client = FlintClient(
         baseUrl: baseUrl ?? _browserOrigin(),
         headers: headers,
         defaultQueryParameters: query,
         timeout: timeout,
         debug: debug,
         throwIfError: throwIfError,
         onError: onError,
         onDone: onDone,
         statusCodeConfig: statusCodeConfig,
       );

  /// Creates a ClientRouter instance.
  ClientRouter.fromClient(this.client, {this.prefix = ''});

  /// The client value.
  final FlintClient client;

  /// The prefix value.
  final String prefix;

  ClientRouter group(String prefix) {
    return ClientRouter.fromClient(client, prefix: _join(this.prefix, prefix));
  }

  Future<FlintResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    JsonParser<T>? parser,
    ErrorHandler? onError,
    RequestDoneCallback<T>? onDone,
    Duration? timeout,
  }) {
    return client.get<T>(
      _path(path),
      queryParameters: query,
      headers: headers,
      parser: parser,
      onError: onError,
      onDone: onDone,
      requestTimeout: timeout,
    );
  }

  Future<FlintResponse<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    JsonParser<T>? parser,
    ErrorHandler? onError,
    RequestDoneCallback<T>? onDone,
    Duration? timeout,
  }) {
    return client.post<T>(
      _path(path),
      body: body,
      queryParameters: query,
      headers: headers,
      parser: parser,
      onError: onError,
      onDone: onDone,
      requestTimeout: timeout,
    );
  }

  Future<FlintResponse<T>> put<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    JsonParser<T>? parser,
    ErrorHandler? onError,
    RequestDoneCallback<T>? onDone,
    Duration? timeout,
  }) {
    return client.put<T>(
      _path(path),
      body: body,
      queryParameters: query,
      headers: headers,
      parser: parser,
      onError: onError,
      onDone: onDone,
      requestTimeout: timeout,
    );
  }

  Future<FlintResponse<T>> patch<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    JsonParser<T>? parser,
    ErrorHandler? onError,
    RequestDoneCallback<T>? onDone,
    Duration? timeout,
  }) {
    return client.patch<T>(
      _path(path),
      body: body,
      queryParameters: query,
      headers: headers,
      parser: parser,
      onError: onError,
      onDone: onDone,
      requestTimeout: timeout,
    );
  }

  Future<FlintResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    JsonParser<T>? parser,
    ErrorHandler? onError,
    RequestDoneCallback<T>? onDone,
    Duration? timeout,
  }) {
    return client.delete<T>(
      _path(path),
      queryParameters: query,
      headers: headers,
      parser: parser,
      onError: onError,
      onDone: onDone,
      requestTimeout: timeout,
    );
  }

  Future<FlintResponse<T>> request<T>(
    String method,
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    JsonParser<T>? parser,
    ErrorHandler? onError,
    RequestDoneCallback<T>? onDone,
    Duration? timeout,
  }) {
    return switch (method.toUpperCase()) {
      'GET' => get<T>(
        path,
        query: query,
        headers: headers,
        parser: parser,
        onError: onError,
        onDone: onDone,
        timeout: timeout,
      ),
      'POST' => post<T>(
        path,
        body: body,
        query: query,
        headers: headers,
        parser: parser,
        onError: onError,
        onDone: onDone,
        timeout: timeout,
      ),
      'PUT' => put<T>(
        path,
        body: body,
        query: query,
        headers: headers,
        parser: parser,
        onError: onError,
        onDone: onDone,
        timeout: timeout,
      ),
      'PATCH' => patch<T>(
        path,
        body: body,
        query: query,
        headers: headers,
        parser: parser,
        onError: onError,
        onDone: onDone,
        timeout: timeout,
      ),
      'DELETE' => delete<T>(
        path,
        query: query,
        headers: headers,
        parser: parser,
        onError: onError,
        onDone: onDone,
        timeout: timeout,
      ),
      _ => throw ArgumentError.value(method, 'method', 'Unsupported method'),
    };
  }

  String _path(String path) {
    final value = path.trim();
    if (_isFullUrl(value)) return value;
    return _join(prefix, value);
  }

  bool _isFullUrl(String path) {
    final uri = Uri.tryParse(path);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  String _join(String left, String right) {
    final a = left.trim();
    final b = right.trim();

    if (a.isEmpty) return b.isEmpty ? '/' : _withLeadingSlash(b);
    if (b.isEmpty || b == '/') return _withLeadingSlash(a);

    final cleanLeft = _withLeadingSlash(a).replaceFirst(RegExp(r'/+$'), '');
    final cleanRight = b.replaceFirst(RegExp(r'^/+'), '');
    return '$cleanLeft/$cleanRight';
  }

  String _withLeadingSlash(String path) {
    return path.startsWith('/') ? path : '/$path';
  }
}

final clientRouter = ClientRouter();

String _browserOrigin() {
  final location = web.window.location;
  final origin = location.origin;

  /// Creates a if instance.
  if (origin.isNotEmpty) return origin;

  final protocol = location.protocol;
  final host = location.host;

  /// Creates a if instance.
  if (protocol.isNotEmpty && host.isNotEmpty) return '$protocol//$host';

  return 'http://localhost';
}
