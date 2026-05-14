import 'package:universal_web/web.dart' as web;

import 'browser_storage.dart';

/// Browser `localStorage` wrapper for persistent key/value data.
class LocalStorage extends BrowserStorage {
  /// Creates a `localStorage` wrapper.
  const LocalStorage();

  /// The browser `localStorage` object.
  @override
  web.Storage get storage => web.window.localStorage;
}

/// Shared persistent browser storage helper.
const localStorage = LocalStorage();
