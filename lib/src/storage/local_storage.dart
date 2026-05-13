import 'package:universal_web/web.dart' as web;

import 'browser_storage.dart';

class LocalStorage extends BrowserStorage {
  const LocalStorage();

  @override
  web.Storage get storage => web.window.localStorage;
}

const localStorage = LocalStorage();
