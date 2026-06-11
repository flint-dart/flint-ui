/// Browser entrypoint APIs for building Flint UI applications.
///
/// Import this from Dart files that mount a browser UI with `createFlintApp`.
/// It includes the core component/widget APIs plus browser rendering, page
/// registry, and stylesheet registration helpers.
library;

export 'flint_ui_core.dart';
export 'src/browser_renderer_stub.dart'
    if (dart.library.js_interop) 'src/browser_renderer.dart';
export 'src/browser_helpers_stub.dart'
    if (dart.library.js_interop) 'src/browser_helpers.dart';
export 'src/pages_stub.dart' if (dart.library.js_interop) 'src/pages.dart';
export 'src/style_browser_stub.dart'
    if (dart.library.js_interop) 'src/style_browser.dart';
