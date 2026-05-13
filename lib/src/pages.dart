import 'dart:convert';

import 'package:universal_web/web.dart' as web;

import 'browser_renderer.dart';
import 'component.dart';
import 'node.dart';
import 'style.dart';
import 'style_browser.dart';
import 'widgets.dart';

typedef FlintPageBuilder = FlintComponent Function(Map<String, dynamic> props);
typedef FlintPageMiddleware = void Function(FlintPageContext context);

class FlintComponentRegistry {
  final Map<String, FlintPageBuilder> _pages = {};

  FlintComponentRegistry([Map<String, FlintPageBuilder>? pages]) {
    if (pages != null) registerAll(pages);
  }

  Map<String, FlintPageBuilder> get pages => Map.unmodifiable(_pages);

  void register(String name, FlintPageBuilder builder) {
    _pages[name] = builder;
  }

  void registerAll(Map<String, FlintPageBuilder> pages) {
    _pages.addAll(pages);
  }

  FlintPageBuilder? operator [](String name) => _pages[name];
}

class FlintPage {
  final String component;
  final Map<String, dynamic> props;
  final String? url;
  final String? version;

  const FlintPage({
    required this.component,
    this.props = const {},
    this.url,
    this.version,
  });

  factory FlintPage.fromJson(Map<String, dynamic> json) {
    return FlintPage(
      component: json['component']?.toString() ?? '',
      props: _asStringKeyedMap(json['props']),
      url: json['url']?.toString(),
      version: json['version']?.toString(),
    );
  }
}

class FlintPageContext {
  FlintPageContext({
    required this.host,
    required this.page,
  });

  final web.Element host;
  final FlintPage page;
  bool _stopped = false;

  bool get stopped => _stopped;

  void stop() {
    _stopped = true;
  }
}

class MissingFlintPage extends FlintComponent {
  final String component;

  MissingFlintPage(this.component);

  @override
  FlintNode build() {
    return Container(
      props: {
        'style': {
          'padding': '24px',
          'font-family': 'system-ui, sans-serif',
        },
      },
      children: [
        Text('Flint page "$component" was not registered.'),
      ],
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
  if (host == null) {
    throw StateError('No element found for selector "$selector".');
  }

  registerRootDesign(
    RootDesign(
      name: 'flint-animations',
      keyframes: [
        StyleKeyframes.spin(),
        StyleKeyframes.fadeIn(),
      ],
    ),
  );

  if (rootDesign != null) {
    registerRootDesign(rootDesign);
  }

  for (final stylesheet in stylesheets) {
    registerStyleSheet(stylesheet);
  }

  final page = _readPage(host);
  final context = FlintPageContext(host: host, page: page);
  for (final middleware in middlewares) {
    middleware(context);
    if (context.stopped) return;
  }

  final builder = registry?[page.component] ?? pages?[page.component];
  final component = builder?.call(page.props) ??
      missingPage?.call(page.component) ??
      MissingFlintPage(page.component);

  createRootForElement(host).render(component);
}

FlintPage _readPage(web.Element host) {
  final encoded = host.getAttribute('data-flint-page');
  if (encoded == null || encoded.trim().isEmpty) {
    throw StateError('Missing data-flint-page payload on Flint app root.');
  }

  final decoded = jsonDecode(encoded);
  if (decoded is! Map<String, dynamic>) {
    throw StateError('Invalid Flint page payload.');
  }

  return FlintPage.fromJson(decoded);
}

Map<String, dynamic> _asStringKeyedMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, entryValue) => MapEntry(key.toString(), entryValue));
  }
  return const {};
}
