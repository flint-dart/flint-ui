import 'package:universal_web/web.dart' as web;

import 'browser_storage.dart';

/// Browser `sessionStorage` wrapper for tab-scoped key/value data.
class SessionStorage extends BrowserStorage {
  /// Creates a `sessionStorage` wrapper.
  const SessionStorage();

  /// The browser `sessionStorage` object.
  @override
  web.Storage get storage => web.window.sessionStorage;
}

/// Shared tab-scoped browser storage helper.
const sessionStorage = SessionStorage();
