import 'dart:convert';

import 'package:universal_web/web.dart' as web;

import 'browser_renderer.dart';
import 'component.dart';
import 'node.dart';
import 'style.dart';
import 'style_browser.dart';
import 'widgets.dart';

/// Function signature used by the FlintPageBuilder API.
typedef FlintPageBuilder = FlintComponent Function(Map<String, dynamic> props);

/// Function signature used by the FlintPageMiddleware API.
typedef FlintPageMiddleware = void Function(FlintPageContext context);

/// Represents the FlintComponentRegistry API in Flint UI.
class FlintComponentRegistry {
  final Map<String, FlintPageBuilder> _pages = {};

  /// Creates a FlintComponentRegistry instance.
  FlintComponentRegistry([Map<String, FlintPageBuilder>? pages]) {
    if (pages != null) registerAll(pages);
  }

  /// Returns the pages value.
  Map<String, FlintPageBuilder> get pages => Map.unmodifiable(_pages);

  /// Runs the register operation.
  void register(String name, FlintPageBuilder builder) {
    _pages[name] = builder;
  }

  /// Runs the registerAll operation.
  void registerAll(Map<String, FlintPageBuilder> pages) {
    _pages.addAll(pages);
  }

  FlintPageBuilder? operator [](String name) => _pages[name];
}

/// Represents the FlintPage API in Flint UI.
class FlintPage {
  /// The component value.
  final String component;

  /// The props value.
  final Map<String, dynamic> props;

  /// The url value.
  final String? url;

  /// The version value.
  final String? version;

  /// Creates a FlintPage instance.
  const FlintPage({
    required this.component,
    this.props = const {},
    this.url,
    this.version,
  });

  /// Creates a FlintPage instance.
  factory FlintPage.fromJson(Map<String, dynamic> json) {
    return FlintPage(
      component: json['component']?.toString() ?? '',
      props: _asStringKeyedMap(json['props']),
      url: json['url']?.toString(),
      version: json['version']?.toString(),
    );
  }
}

/// Represents the FlintPageContext API in Flint UI.
class FlintPageContext {
  /// Creates a FlintPageContext instance.
  FlintPageContext({required this.host, required this.page});

  /// The host value.
  final web.Element host;

  /// The page value.
  final FlintPage page;
  bool _stopped = false;

  /// Returns the stopped value.
  bool get stopped => _stopped;

  /// Runs the stop operation.
  void stop() {
    _stopped = true;
  }
}

/// Represents the MissingFlintPage API in Flint UI.
class MissingFlintPage extends FlintComponent {
  /// The component value.
  final String component;

  /// Creates a MissingFlintPage instance.
  MissingFlintPage(this.component);

  @override
  /// Runs the build operation.
  FlintNode build() {
    return Container(
      props: {
        'style': {'padding': '24px', 'font-family': 'system-ui, sans-serif'},
      },
      children: [Text('Flint page "$component" was not registered.')],
    );
  }
}

void createFlintApp(
  String selector, {
  Map<String, FlintPageBuilder>? pages,
  FlintComponentRegistry? registry,
  List<FlintPageMiddleware> middlewares = const [],
  List<StyleSheet> stylesheets = const [],
  RootDesign? rootDesign,
  FlintComponent Function(String component)? missingPage,
}) {
  final host = web.document.querySelector(selector);

  /// Creates a if instance.
  if (host == null) {
    throw StateError('No element found for selector "$selector".');
  }

  /// Creates a registerRootDesign instance.
  registerRootDesign(
    RootDesign(
      name: 'flint-animations',
      keyframes: [StyleKeyframes.spin(), StyleKeyframes.fadeIn()],
    ),
  );

  /// Creates a if instance.
  if (rootDesign != null) {
    registerRootDesign(rootDesign);
  }

  /// Creates a for instance.
  for (final stylesheet in stylesheets) {
    registerStyleSheet(stylesheet);
  }

  final page = _readPage(host);
  final context = FlintPageContext(host: host, page: page);

  /// Creates a for instance.
  for (final middleware in middlewares) {
    middleware(context);
    if (context.stopped) return;
  }

  final builder = registry?[page.component] ?? pages?[page.component];
  final component =
      builder?.call(page.props) ??
      missingPage?.call(page.component) ??
      MissingFlintPage(page.component);

  /// Creates a createRootForElement instance.
  createRootForElement(host).render(component);
}

FlintPage _readPage(web.Element host) {
  final encoded = host.getAttribute('data-flint-page');

  /// Creates a if instance.
  if (encoded == null || encoded.trim().isEmpty) {
    throw StateError('Missing data-flint-page payload on Flint app root.');
  }

  final decoded = jsonDecode(encoded);

  /// Creates a if instance.
  if (decoded is! Map<String, dynamic>) {
    throw StateError('Invalid Flint page payload.');
  }

  return FlintPage.fromJson(decoded);
}

Map<String, dynamic> _asStringKeyedMap(Object? value) {
  /// Creates a if instance.
  if (value is Map<String, dynamic>) return value;

  /// Creates a if instance.
  if (value is Map) {
    return value.map((key, entryValue) => MapEntry(key.toString(), entryValue));
  }
  return const {};
}
