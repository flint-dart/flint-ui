import 'dart:js_interop';

import 'package:universal_web/web.dart' as web;

/// Represents the BrowserNavigation API in Flint UI.
class BrowserNavigation {
  /// Creates a BrowserNavigation instance.
  const BrowserNavigation();

  /// Returns the currentUrl value.
  String get currentUrl => web.window.location.href;

  /// Returns the currentPath value.
  String get currentPath => web.window.location.pathname;

  /// Returns the currentQuery value.
  String get currentQuery => web.window.location.search;

  /// Returns the currentHash value.
  String get currentHash => web.window.location.hash;

  /// Returns the currentUri value.
  Uri get currentUri => Uri.parse(currentUrl);

  /// Runs the navigate operation.
  void navigate(String url, {Object? state}) {
    web.window.history.pushState(_toJsState(state), '', url);
  }

  /// Runs the replace operation.
  void replace(String url, {Object? state}) {
    web.window.history.replaceState(_toJsState(state), '', url);
  }

  /// Runs the assign operation.
  void assign(String url) {
    web.window.location.assign(url);
  }

  /// Runs the redirect operation.
  void redirect(String url) {
    web.window.location.replace(url);
  }

  /// Runs the back operation.
  void back() {
    web.window.history.back();
  }

  /// Runs the forward operation.
  void forward() {
    web.window.history.forward();
  }

  /// Runs the go operation.
  void go(int delta) {
    web.window.history.go(delta);
  }

  /// Runs the reload operation.
  void reload() {
    web.window.location.reload();
  }

  JSAny? _toJsState(Object? state) {
    return state == null ? null : state.jsify();
  }
}

const navigation = BrowserNavigation();

String get currentUrl => navigation.currentUrl;

String get currentPath => navigation.currentPath;

String get currentQuery => navigation.currentQuery;

String get currentHash => navigation.currentHash;

Uri get currentUri => navigation.currentUri;

void navigate(String url, {Object? state}) {
  /// Creates a navigation instance.
  navigation.navigate(url, state: state);
}

void replace(String url, {Object? state}) {
  /// Creates a navigation instance.
  navigation.replace(url, state: state);
}

void back() {
  /// Creates a navigation instance.
  navigation.back();
}

void forward() {
  /// Creates a navigation instance.
  navigation.forward();
}

void go(int delta) {
  /// Creates a navigation instance.
  navigation.go(delta);
}

void reload() {
  /// Creates a navigation instance.
  navigation.reload();
}
