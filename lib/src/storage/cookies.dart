import 'package:universal_web/web.dart' as web;

/// Options for the CookieSameSite API.
enum CookieSameSite { lax, strict, none }

/// Represents the Cookies API in Flint UI.
class Cookies {
  /// Creates a Cookies instance.
  const Cookies();

  /// Runs the read operation.
  String? read(String name) {
    return readAll()[name];
  }

  /// Runs the readAll operation.
  Map<String, String> readAll() {
    final cookie = web.document.cookie;
    if (cookie.isEmpty) return const {};

    final values = <String, String>{};
    for (final part in cookie.split(';')) {
      final pair = part.trim();
      if (pair.isEmpty) continue;

      final separator = pair.indexOf('=');
      if (separator < 0) {
        values[_decode(pair)] = '';
        continue;
      }

      final name = pair.substring(0, separator);
      final value = pair.substring(separator + 1);
      values[_decode(name)] = _decode(value);
    }

    return values;
  }

  /// Runs the has operation.
  bool has(String name) {
    return read(name) != null;
  }

  /// Runs the write operation.
  void write(
    String name,
    String value, {
    DateTime? expires,
    Duration? maxAge,
    String path = '/',
    String? domain,
    bool secure = false,
    CookieSameSite? sameSite,
  }) {
    web.document.cookie = _buildCookie(
      name,
      value,
      expires: expires,
      maxAge: maxAge,
      path: path,
      domain: domain,
      secure: secure,
      sameSite: sameSite,
    );
  }

  /// Runs the remove operation.
  void remove(
    String name, {
    String path = '/',
    String? domain,
    bool secure = false,
    CookieSameSite? sameSite,
  }) {
    write(
      name,
      '',
      expires: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      maxAge: Duration.zero,
      path: path,
      domain: domain,
      secure: secure,
      sameSite: sameSite,
    );
  }

  /// Runs the clear operation.
  void clear({String path = '/'}) {
    for (final name in readAll().keys) {
      remove(name, path: path);
    }
  }

  String _buildCookie(
    String name,
    String value, {
    DateTime? expires,
    Duration? maxAge,
    String path = '/',
    String? domain,
    bool secure = false,
    CookieSameSite? sameSite,
  }) {
    final parts = <String>[
      '${_encode(name)}=${_encode(value)}',
      if (expires != null) 'Expires=${_formatHttpDate(expires)}',
      if (maxAge != null) 'Max-Age=${maxAge.inSeconds}',
      if (path.isNotEmpty) 'Path=$path',
      if (domain != null && domain.isNotEmpty) 'Domain=$domain',
      if (secure) 'Secure',
      if (sameSite != null) 'SameSite=${_formatSameSite(sameSite)}',
    ];

    return parts.join('; ');
  }

  String _formatSameSite(CookieSameSite sameSite) {
    return switch (sameSite) {
      CookieSameSite.lax => 'Lax',
      CookieSameSite.strict => 'Strict',
      CookieSameSite.none => 'None',
    };
  }

  String _formatHttpDate(DateTime date) {
    final value = date.toUtc();
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final weekday = weekdays[value.weekday - 1];
    final day = value.day.toString().padLeft(2, '0');
    final month = months[value.month - 1];
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');

    return '$weekday, $day $month ${value.year} $hour:$minute:$second GMT';
  }

  String _encode(String value) => Uri.encodeComponent(value);

  String _decode(String value) => Uri.decodeComponent(value);
}

const cookies = Cookies();
