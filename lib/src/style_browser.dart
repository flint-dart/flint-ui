import 'package:universal_web/web.dart' as web;

import 'style.dart';

final Set<String> _registeredStyleSheets = {};
final Set<String> _registeredRootDesigns = {};

void registerRootDesign(RootDesign design) {
  if (_registeredRootDesigns.contains(design.name)) return;

  final cssText = design.cssText;
  if (cssText.trim().isEmpty) return;

  final head = web.document.querySelector('head');
  if (head == null) return;

  final element = web.document.createElement('style');
  element.setAttribute('data-flint-root-design', design.name);
  element.textContent = cssText;
  head.appendChild(element);
  _registeredRootDesigns.add(design.name);
}

void registerStyleSheet(StyleSheet stylesheet) {
  if (_registeredStyleSheets.contains(stylesheet.name)) return;

  final head = web.document.querySelector('head');
  if (head == null) return;

  final element = web.document.createElement('style');
  element.setAttribute('data-flint-stylesheet', stylesheet.name);
  element.textContent = stylesheet.cssText;
  head.appendChild(element);
  _registeredStyleSheets.add(stylesheet.name);
}
