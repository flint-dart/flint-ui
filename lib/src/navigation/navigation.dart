import 'dart:js_interop';

import 'package:universal_web/web.dart' as web;

class BrowserNavigation {
  const BrowserNavigation();

  String get currentUrl => web.window.location.href;

  String get currentPath => web.window.location.pathname;

  String get currentQuery => web.window.location.search;

  String get currentHash => web.window.location.hash;

  Uri get currentUri => Uri.parse(currentUrl);

  void navigate(String url, {Object? state}) {
    web.window.history.pushState(_toJsState(state), '', url);
  }

  void replace(String url, {Object? state}) {
    web.window.history.replaceState(_toJsState(state), '', url);
  }

  void assign(String url) {
    web.window.location.assign(url);
  }

  void redirect(String url) {
    web.window.location.replace(url);
  }

  void back() {
    web.window.history.back();
  }

  void forward() {
    web.window.history.forward();
  }

  void go(int delta) {
    web.window.history.go(delta);
  }

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
  navigation.navigate(url, state: state);
}

void replace(String url, {Object? state}) {
  navigation.replace(url, state: state);
}

void back() {
  navigation.back();
}

void forward() {
  navigation.forward();
}

void go(int delta) {
  navigation.go(delta);
}

void reload() {
  navigation.reload();
}
