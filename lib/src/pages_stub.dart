import 'dart:async';
import 'dart:convert';

import 'component.dart';
import 'component_registry.dart';
import 'node.dart';
import 'widgets.dart';

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
  FlintPageContext({required this.host, required this.page});

  final Object? host;
  final FlintPage page;
  bool _stopped = false;

  bool get stopped => _stopped;

  void stop() {
    _stopped = true;
  }
}

typedef FlintPageMiddleware = void Function(FlintPageContext context);

typedef FlintAsyncPageBuilder =
    FutureOr<FlintPageBuilder?> Function(String component);

class MissingFlintPage extends StatelessComponent {
  MissingFlintPage(this.component);

  final String component;

  @override
  FlintNode build() {
    return Container(
      props: const {
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
  FlintAsyncPageBuilder? resolvePage,
  List<FlintPageMiddleware> middlewares = const [],
  List<Object> stylesheets = const [],
  Object? rootDesign,
  FlintComponent Function(String component)? missingPage,
}) {
  throw UnsupportedError('createFlintApp is only available in the browser.');
}

Map<String, dynamic> _asStringKeyedMap(Object? value) {
  if (value is Map<String, dynamic>) return value;

  if (value is Map) {
    return value.map((key, entryValue) => MapEntry(key.toString(), entryValue));
  }
  return const {};
}

Map<String, dynamic> decodeFlintPagePayload(String value) {
  final decoded = jsonDecode(value);
  if (decoded is Map<String, dynamic>) return decoded;
  throw StateError('Invalid Flint page payload.');
}
