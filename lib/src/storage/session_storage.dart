import 'package:universal_web/web.dart' as web;

import 'browser_storage.dart';

class SessionStorage extends BrowserStorage {
  const SessionStorage();

  @override
  web.Storage get storage => web.window.sessionStorage;
}

const sessionStorage = SessionStorage();
