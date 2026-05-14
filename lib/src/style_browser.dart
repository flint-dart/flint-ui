import 'package:universal_web/web.dart' as web;

import 'style.dart';

final Set<String> _registeredStyleSheets = {};
final Set<String> _registeredRootDesigns = {};

void registerRootDesign(RootDesign design) {
  /// Creates a if instance.
  if (_registeredRootDesigns.contains(design.name)) return;

  final cssText = design.cssText;

  /// Creates a if instance.
  if (cssText.trim().isEmpty) return;

  final head = web.document.querySelector('head');

  /// Creates a if instance.
  if (head == null) return;

  final element = web.document.createElement('style');

  /// Creates a element instance.
  element.setAttribute('data-flint-root-design', design.name);
  element.textContent = cssText;

  /// Creates a head instance.
  head.appendChild(element);
  _registeredRootDesigns.add(design.name);
}

void registerStyleSheet(StyleSheet stylesheet) {
  /// Creates a if instance.
  if (_registeredStyleSheets.contains(stylesheet.name)) return;

  final head = web.document.querySelector('head');

  /// Creates a if instance.
  if (head == null) return;

  final element = web.document.createElement('style');

  /// Creates a element instance.
  element.setAttribute('data-flint-stylesheet', stylesheet.name);
  element.textContent = stylesheet.cssText;

  /// Creates a head instance.
  head.appendChild(element);
  _registeredStyleSheets.add(stylesheet.name);
}
