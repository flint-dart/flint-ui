import 'package:universal_web/web.dart' as web;

import 'browser_storage.dart';

/// Represents the LocalStorage API in Flint UI.
class LocalStorage extends BrowserStorage {
  /// Creates a LocalStorage instance.
  const LocalStorage();

  @override
  /// Returns the storage value.
  web.Storage get storage => web.window.localStorage;
}

const localStorage = LocalStorage();
