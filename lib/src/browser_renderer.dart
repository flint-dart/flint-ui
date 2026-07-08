import 'dart:async';
import 'dart:js_interop';

import 'package:universal_web/web.dart' as web;

import 'component.dart';
import 'node.dart';
import 'widgets/primitives/canvas.dart';
import 'widgets/primitives/media_preview.dart';

/// Browser DOM root that renders Flint nodes into a host element.
class FlintRoot {
  /// Host element that receives rendered DOM nodes.
  final web.Element host;
  FlintNode? _node;
  Map<String, _ComponentMount> _componentSlots = {};
  bool _renderQueued = false;
  bool _mounted = false;

  /// Creates a root renderer for [host].
  FlintRoot(this.host);

  /// Renders [node] into the host element.
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

    final activeControl = _ActiveControl.capture(host);
    final previousSlots = _componentSlots;
    final nextSlots = <String, _ComponentMount>{};
    host.textContent = '';
    host.appendChild(_createDom(node, '0', previousSlots, nextSlots));
    activeControl?.restore(host);
    for (final entry in previousSlots.entries) {
      if (!nextSlots.containsKey(entry.key)) {
        _unmountComponentTree(entry.value);
      }
    }
    _componentSlots = nextSlots;
    _mounted = true;
  }

  web.Node _createDom(
    FlintNode node,
    String path,
    Map<String, _ComponentMount> previousSlots,
    Map<String, _ComponentMount> nextSlots,
  ) {
    return switch (node) {
      FlintText(:final value) => web.document.createTextNode(value),
      FlintRawHtml(:final value, :final trusted) => _createRawHtml(
        value,
        trusted,
      ),
      FlintFragment(:final children) => _createFragment(
        children,
        path,
        previousSlots,
        nextSlots,
      ),
      FlintElement(:final tag, :final props, :final children) => _createElement(
        tag,
        props,
        children,
        path,
        previousSlots,
        nextSlots,
      ),
      FlintComponent() => _createComponent(
        node,
        path,
        previousSlots,
        nextSlots,
      ),
      FlintComponentNode(:final component) => _createComponent(
        component,
        path,
        previousSlots,
        nextSlots,
      ),
      _ => throw UnsupportedError(
        'Unsupported FlintNode type: ${node.runtimeType}',
      ),
    };
  }

  web.Node _createRawHtml(String value, bool trusted) {
    if (!trusted) return web.document.createTextNode(value);

    final template =
        web.document.createElement('template') as web.HTMLTemplateElement;
    template.innerHTML = value.toJS;
    return template.content.cloneNode(true);
  }

  web.DocumentFragment _createFragment(
    List<FlintNode> children,
    String path,
    Map<String, _ComponentMount> previousSlots,
    Map<String, _ComponentMount> nextSlots,
  ) {
    final fragment = web.document.createDocumentFragment();
    for (var i = 0; i < children.length; i++) {
      fragment.appendChild(
        _createDom(children[i], '$path.$i', previousSlots, nextSlots),
      );
    }
    return fragment;
  }

  web.Element _createElement(
    String tag,
    Map<String, Object?> props,
    List<FlintNode> children,
    String path,
    Map<String, _ComponentMount> previousSlots,
    Map<String, _ComponentMount> nextSlots,
  ) {
    final element = _createDomElement(tag);
    _applyProps(element, props);

    for (var i = 0; i < children.length; i++) {
      element.appendChild(
        _createDom(children[i], '$path.$i', previousSlots, nextSlots),
      );
    }

    return element;
  }

  web.Element _createDomElement(String tag) {
    if (_svgTags.contains(tag)) {
      return web.document.createElementNS('http://www.w3.org/2000/svg', tag);
    }

    return web.document.createElement(tag);
  }

  web.Node _createComponent(
    FlintComponent component,
    String path,
    Map<String, _ComponentMount> previousSlots,
    Map<String, _ComponentMount> nextSlots,
  ) {
    final previous = previousSlots[path];
    final hasExisting =
        previous != null &&
        previous.component.runtimeType == component.runtimeType &&
        previous.component.preserveState &&
        component.preserveState;
    final mount = hasExisting
        ? previous
        : _ComponentMount(
            component,
            web.document.createElement('flint-component'),
          );
    if (previous != null && !hasExisting) {
      _unmountComponentTree(previous);
    }
    nextSlots[path] = mount;

    if (hasExisting) {
      mount.component.updateFrom(component);
    }
    mount.component.attach(() => _scheduleComponentRender(mount));
    _renderComponent(mount);

    if (_mounted && hasExisting) {
      mount.component.didUpdate();
    } else {
      scheduleMicrotask(mount.component.didMount);
    }

    return mount.boundary;
  }

  void _scheduleComponentRender(_ComponentMount mount) {
    if (mount.renderQueued) return;
    mount.renderQueued = true;
    scheduleMicrotask(() {
      mount.renderQueued = false;
      _renderComponent(mount);
      if (mount.mounted) {
        mount.component.didUpdate();
      }
    });
  }

  void _renderComponent(_ComponentMount mount) {
    final previousSlots = mount.childSlots;
    final nextSlots = <String, _ComponentMount>{};
    final activeControl = _ActiveControl.capture(mount.boundary);

    mount.boundary.textContent = '';
    mount.boundary.setAttribute('style', 'display: contents;');
    mount.boundary.appendChild(
      _createDom(
        _normalize(mount.component.build()),
        'c',
        previousSlots,
        nextSlots,
      ),
    );
    activeControl?.restore(mount.boundary);

    for (final entry in previousSlots.entries) {
      if (!nextSlots.containsKey(entry.key)) {
        _unmountComponentTree(entry.value);
      }
    }

    mount.childSlots = nextSlots;
    mount.mounted = true;
  }

  void _unmountComponentTree(_ComponentMount mount) {
    for (final child in mount.childSlots.values) {
      _unmountComponentTree(child);
    }
    mount.component.willUnmount();
  }

  void _applyProps(web.Element element, Map<String, Object?> props) {
    props.forEach((name, value) {
      if (value == null || value == false) return;

      if (name == '_flintStyleCss') {
        _registerScopedStyle(value.toString());
        return;
      }

      if (name == '_flintMediaController') {
        if (value is MediaElementController) {
          value.attachTo(element);
        }
        return;
      }

      if (name == '_flintCanvasController') {
        if (value is CanvasController) {
          value.attachTo(element);
        }
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

      if (_applyFormProperty(element, name, value)) {
        return;
      }

      if (_applyMediaProperty(element, name, value)) {
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

  bool _applyFormProperty(web.Element element, String name, Object value) {
    if (name == 'value') {
      if (element is web.HTMLInputElement) {
        element.value = value.toString();
        return true;
      }
      if (element is web.HTMLTextAreaElement) {
        element.value = value.toString();
        return true;
      }
      if (element is web.HTMLSelectElement) {
        element.value = value.toString();
        return true;
      }
    }

    if (name == 'checked' && element is web.HTMLInputElement) {
      element.checked = value == true;
      if (value == true) {
        element.setAttribute(name, '');
      }
      return true;
    }

    return false;
  }

  bool _applyMediaProperty(web.Element element, String name, Object value) {
    if (element is web.HTMLMediaElement) {
      if (name == 'muted') {
        element.muted = value == true;
        if (value == true) element.setAttribute(name, '');
        return true;
      }
      if (name == 'controls') {
        element.controls = value == true;
        if (value == true) element.setAttribute(name, '');
        return true;
      }
      if (name == 'autoplay') {
        element.autoplay = value == true;
        if (value == true) element.setAttribute(name, '');
        return true;
      }
      if (name == 'loop') {
        element.loop = value == true;
        if (value == true) element.setAttribute(name, '');
        return true;
      }
    }

    if (name == 'playsinline' && element is web.HTMLVideoElement) {
      element.playsInline = value == true;
      if (value == true) element.setAttribute(name, '');
      return true;
    }

    return false;
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
      }).toJS,
    );
  }

  FlintNode _normalize(Object? node) {
    if (node is FlintNode) return node;
    if (node is FlintComponent) return FlintComponentNode(node);
    return FlintText(node?.toString() ?? '');
  }
}

const _svgTags = {
  'svg',
  'path',
  'line',
  'polyline',
  'polygon',
  'circle',
  'rect',
  'ellipse',
  'title',
  'g',
};

/// Creates a root renderer for the first element matching [selector].
FlintRoot createRoot(String selector) {
  final element = web.document.querySelector(selector);

  if (element == null) {
    throw StateError('No element found for selector "$selector".');
  }

  return FlintRoot(element);
}

/// Creates a root renderer for an existing browser [element].
FlintRoot createRootForElement(web.Element element) => FlintRoot(element);

class _ComponentMount {
  final FlintComponent component;
  final web.Element boundary;
  Map<String, _ComponentMount> childSlots = {};
  bool renderQueued = false;
  bool mounted = false;

  _ComponentMount(this.component, this.boundary);
}

class _ActiveControl {
  _ActiveControl({
    required this.tag,
    required this.value,
    this.id,
    this.name,
    this.type,
    this.selectionStart,
    this.selectionEnd,
  });

  final String tag;
  final String value;
  final String? id;
  final String? name;
  final String? type;
  final int? selectionStart;
  final int? selectionEnd;

  static _ActiveControl? capture(web.Element scope) {
    final active = web.document.activeElement;
    if (active == null || !scope.contains(active)) return null;

    if (active is web.HTMLInputElement) {
      return _ActiveControl(
        tag: 'input',
        value: active.value,
        id: active.id.isEmpty ? null : active.id,
        name: active.name.isEmpty ? null : active.name,
        type: active.type.isEmpty ? null : active.type,
        selectionStart: active.selectionStart,
        selectionEnd: active.selectionEnd,
      );
    }

    if (active is web.HTMLTextAreaElement) {
      return _ActiveControl(
        tag: 'textarea',
        value: active.value,
        id: active.id.isEmpty ? null : active.id,
        name: active.name.isEmpty ? null : active.name,
        selectionStart: active.selectionStart,
        selectionEnd: active.selectionEnd,
      );
    }

    return null;
  }

  void restore(web.Element scope) {
    final control = _find(scope);
    if (control == null) return;

    if (control is web.HTMLInputElement) {
      control.value = value;
      control.focus();
      _restoreSelection(control);
      return;
    }

    if (control is web.HTMLTextAreaElement) {
      control.value = value;
      control.focus();
      _restoreSelection(control);
    }
  }

  web.Element? _find(web.Element scope) {
    if (id != null) {
      final byId = web.document.getElementById(id!);
      if (byId != null && scope.contains(byId) && _matches(byId)) {
        return byId;
      }
    }

    final controls = scope.querySelectorAll(tag);
    for (var i = 0; i < controls.length; i++) {
      final candidate = controls.item(i);
      if (candidate is web.Element && _matches(candidate)) {
        return candidate;
      }
    }

    return null;
  }

  bool _matches(web.Element element) {
    if (element.localName != tag) return false;

    if (element is web.HTMLInputElement) {
      if (type != null && element.type != type) return false;
      if (name != null && element.name == name) return true;
      return id != null && element.id == id;
    }

    if (element is web.HTMLTextAreaElement) {
      if (name != null && element.name == name) return true;
      return id != null && element.id == id;
    }

    return false;
  }

  void _restoreSelection(dynamic control) {
    final start = selectionStart;
    final end = selectionEnd;
    if (start == null || end == null) return;

    try {
      control.setSelectionRange(start, end);
    } catch (_) {
      // Some input types, such as number/date, do not support text selection.
    }
  }
}
