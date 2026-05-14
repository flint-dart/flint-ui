import 'package:universal_web/web.dart' as web;

import 'browser_storage.dart';

/// Represents the SessionStorage API in Flint UI.
class SessionStorage extends BrowserStorage {
  /// Creates a SessionStorage instance.
  const SessionStorage();

  @override
  /// Returns the storage value.
  web.Storage get storage => web.window.sessionStorage;
}

const sessionStorage = SessionStorage();
