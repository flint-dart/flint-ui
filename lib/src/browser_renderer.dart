import 'dart:async';
import 'dart:js_interop';

import 'package:universal_web/web.dart' as web;

import 'component.dart';
import 'node.dart';

class FlintRoot {
  final web.Element host;
  FlintNode? _node;
  bool _renderQueued = false;
  bool _mounted = false;

  FlintRoot(this.host);

  void render(Object? node) {
    _node = _normalize(node);
    _scheduleRender();
  }

  void _scheduleRender() {
    if (_renderQueued) return;
    _renderQueued = true;
    scheduleMicrotask(() {
      _renderQueued = false;
      _paint();
    });
  }

  void _paint() {
    final node = _node;
    if (node == null) return;

    host.textContent = '';
    host.appendChild(_createDom(node));
    _mounted = true;
  }

  web.Node _createDom(FlintNode node) {
    return switch (node) {
      FlintText(:final value) => web.document.createTextNode(value),
      FlintFragment(:final children) => _createFragment(children),
      FlintElement(:final tag, :final props, :final children) =>
        _createElement(tag, props, children),
      FlintComponentNode(:final component) => _createComponent(component),
    };
  }

  web.DocumentFragment _createFragment(List<FlintNode> children) {
    final fragment = web.document.createDocumentFragment();
    for (final child in children) {
      fragment.appendChild(_createDom(child));
    }
    return fragment;
  }

  web.Element _createElement(
    String tag,
    Map<String, Object?> props,
    List<FlintNode> children,
  ) {
    final element = web.document.createElement(tag);
    _applyProps(element, props);

    for (final child in children) {
      element.appendChild(_createDom(child));
    }

    return element;
  }

  web.Node _createComponent(FlintComponent component) {
    component.attach(_scheduleRender);
    final child = _createDom(component.build());

    if (_mounted) {
      component.didUpdate();
    } else {
      scheduleMicrotask(component.didMount);
    }

    return child;
  }

  void _applyProps(web.Element element, Map<String, Object?> props) {
    props.forEach((name, value) {
      if (value == null || value == false) return;

      if (name == '_flintStyleCss') {
        _registerScopedStyle(value.toString());
        return;
      }

      if (name == 'className') {
        element.className = value.toString();
        return;
      }

      if (name == 'style') {
        _applyStyle(element, value);
        return;
      }

      if (name.startsWith('on') && value is Function) {
        _listen(element, name.substring(2).toLowerCase(), value);
        return;
      }

      if (value == true) {
        element.setAttribute(name, '');
        return;
      }

      element.setAttribute(name, value.toString());
    });
  }

  void _registerScopedStyle(String cssText) {
    if (cssText.trim().isEmpty) return;

    final id = 'flint-style-${cssText.hashCode}';
    if (web.document.querySelector('style[data-flint-style-id="$id"]') !=
        null) {
      return;
    }

    final head = web.document.querySelector('head');
    if (head == null) return;

    final element = web.document.createElement('style');
    element.setAttribute('data-flint-style-id', id);
    element.textContent = cssText;
    head.appendChild(element);
  }

  void _applyStyle(web.Element element, Object? value) {
    if (value is String) {
      element.setAttribute('style', value);
      return;
    }

    if (value is Map<String, Object?>) {
      final style = value.entries
          .where((entry) => entry.value != null)
          .map((entry) => '${entry.key}: ${entry.value}')
          .join('; ');
      element.setAttribute('style', style);
    }
  }

  void _listen(web.Element element, String eventName, Function handler) {
    element.addEventListener(
        eventName,
        ((web.Event event) {
          handler(event);
        }).toJS);
  }

  FlintNode _normalize(Object? node) {
    if (node is FlintNode) return node;
    if (node is FlintComponent) return FlintComponentNode(node);
    return FlintText(node?.toString() ?? '');
  }
}

FlintRoot createRoot(String selector) {
  final element = web.document.querySelector(selector);
  if (element == null) {
    throw StateError('No element found for selector "$selector".');
  }

  return FlintRoot(element);
}

FlintRoot createRootForElement(web.Element element) => FlintRoot(element);
