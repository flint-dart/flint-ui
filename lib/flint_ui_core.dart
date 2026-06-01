/// Core component, node, style, storage, navigation, and widget APIs.
///
/// Import this from tests, shared component packages, and lower-level code that
/// should use Flint UI primitives without directly depending on app mounting
/// helpers.
library;

export 'src/auth/auth_session.dart';
export 'src/browser/document_stub.dart'
    if (dart.library.js_interop) 'src/browser/document.dart';
export 'src/client/client_router.dart';
export 'src/component_props.dart' hide toFlintNode;
export 'src/component_registry.dart';
export 'src/component.dart';
export 'src/config/environment_config_stub.dart'
    if (dart.library.js_interop) 'src/config/environment_config.dart';
export 'src/data/resource.dart';
export 'src/head.dart';
export 'src/html.dart';
export 'src/navigation/navigation_stub.dart'
    if (dart.library.js_interop) 'src/navigation/navigation.dart';
export 'src/navigation/query_params_stub.dart'
    if (dart.library.js_interop) 'src/navigation/query_params.dart';
export 'src/node.dart';
export 'src/storage/browser_storage.dart';
export 'src/storage/cookies.dart';
export 'src/storage/local_storage.dart';
export 'src/storage/session_storage.dart';
export 'src/state/state_signal.dart';
export 'src/style.dart';
export 'src/widgets.dart';
