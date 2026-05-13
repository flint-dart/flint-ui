# Flint UI

`flint_ui` is a Dart-first web UI layer for Flint fullstack applications. It gives you a small component model, browser rendering, page mounting, typed style helpers, browser storage, navigation utilities, and a growing set of application components.

The goal is simple: build real FlintDart web interfaces in Dart without reaching for raw HTML, JavaScript, and CSS strings for every screen.

## Status

Flint UI is pre-1.0 and actively evolving. The current package is suitable for building FlintDart app UIs and internal dashboards, but APIs may still change while the v1 surface is shaped.

## Install

Add `flint_ui` to your app:

```yaml
dependencies:
  flint_ui: ^0.1.0
```

For local Flint development inside this monorepo, use a path override:

```yaml
dependency_overrides:
  flint_ui:
    path: ../flint_ui
```

Import the full UI package:

```dart
import 'package:flint_ui/flint_ui.dart';
```

For lower-level tests or package internals, you can import:

```dart
import 'package:flint_ui/flint_ui_core.dart';
```

## Quick Start

Create a Flint UI entry file, usually `flint_ui/main.dart`:

```dart
import 'package:flint_ui/flint_ui.dart';

void main() {
  createFlintApp(
    '#app',
    pages: {
      'Home': (_) => HomePage(),
    },
  );
}

class HomePage extends FlintComponent {
  @override
  FlintNode build() {
    return Container(
      dartStyle: const DartStyle(
        padding: EdgeInsets.all(24),
        maxWidth: SizeValue.rem(48),
      ),
      children: [
        Text.h1('Hello Flint UI'),
        Text.p('Build browser UI with Dart components.'),
        Button(
          child: 'Continue',
          onPressed: (_) {
            navigation.assign('/dashboard');
          },
        ),
      ],
    );
  }
}
```

Render the page from FlintDart:

```dart
Response home(Request req, Response res) {
  return res.page(
    'Home',
    title: 'My Flint App',
    script: '/main.dart.js',
    props: {
      'name': 'Flint',
    },
  );
}
```

Compile the UI:

```bash
dart compile js flint_ui/main.dart -o public/main.dart.js
```

When used through FlintDart hot reload, Flint can compile the UI bundle and refresh the browser for you.

## Components

Every UI component is a `FlintComponent` that returns a `FlintNode`.

```dart
class Counter extends FlintComponent {
  int value = 0;

  @override
  FlintNode build() {
    return Row(
      dartStyle: const DartStyle(
        display: Display.flex,
        gap: 12,
        alignItems: AlignItems.center,
      ),
      children: [
        Text.span('Count: $value'),
        Button(
          child: 'Add',
          onPressed: (_) {
            setState(() => value++);
          },
        ),
      ],
    );
  }
}
```

Lifecycle hooks are available:

```dart
class Example extends FlintComponent {
  @override
  void didMount() {}

  @override
  void didUpdate() {}

  @override
  void willUnmount() {}

  @override
  FlintNode build() => Text('Example');
}
```

## Basic Nodes

You can use high-level components:

```dart
Column(
  children: [
    Text.h2('Account'),
    Text.p('Manage your profile.'),
  ],
)
```

Or create raw elements:

```dart
h(
  'section',
  props: {'class': 'panel'},
  children: [
    text('Raw element'),
  ],
)
```

Common helpers include:

```dart
div()
span()
button()
input()
text()
fragment()
component()
toFlintNode()
```

## Pages And Registry

For multi-page apps, use `FlintComponentRegistry`:

```dart
final componentRegistry = FlintComponentRegistry({
  'Login': (props) => LoginPage(props),
  'Dashboard': (props) => DashboardPage(props),
});

void main() {
  createFlintApp(
    '#app',
    registry: componentRegistry,
  );
}
```

A page receives server props through `data-flint-page`:

```dart
class DashboardPage extends FlintComponent {
  DashboardPage(this.props);

  final Map<String, dynamic> props;

  @override
  FlintNode build() {
    final role = props['role']?.toString() ?? 'customer';
    return Text.h1('Dashboard: $role');
  }
}
```

## Page Middleware

Client-side page middleware can stop rendering or redirect before a page mounts:

```dart
const session = AuthSessionManager(
  tokenKey: 'app.token',
  userKey: 'app.user',
);

void requireAuth(FlintPageContext context) {
  if (context.page.component != 'Dashboard') return;
  if (session.isLoggedIn) return;

  navigation.redirect('/login');
  context.stop();
}

void main() {
  createFlintApp(
    '#app',
    registry: componentRegistry,
    middlewares: [requireAuth],
  );
}
```

For real protection, also guard the server route in FlintDart.

## Styling

Flint UI supports plain style maps and the typed `DartStyle` API.

```dart
Container(
  dartStyle: const DartStyle(
    padding: EdgeInsets.all(24),
    background: Colors.white,
    color: Colors.slate900,
    radius: 12,
    border: Border.all(color: Colors.slate200),
    shadow: Shadow(
      y: 16,
      blur: 40,
      color: Color.rgba(15, 23, 42, 0.12),
    ),
  ),
  child: Text('Styled panel'),
)
```

### Size Values

Numbers become pixels by default:

```dart
DartStyle(width: 320) // width: 320px
```

Use `SizeValue` when you want another unit:

```dart
const DartStyle(
  width: SizeValue.full,
  maxWidth: SizeValue.rem(48),
  height: SizeValue.auto,
)
```

Available helpers:

```dart
SizeValue.px(12)
SizeValue.percent(50)
SizeValue.rem(4)
SizeValue.em(2)
SizeValue.auto
SizeValue.full
```

### Colors

Use CSS strings, `Color`, or predefined `Colors`:

```dart
const DartStyle(color: '#0f172a')
const DartStyle(color: Color.rgb(15, 23, 42))
const DartStyle(color: Color.rgba(37, 99, 235, 0.9))
const DartStyle(color: Colors.blue600)
```

Current named colors include:

```dart
Colors.white
Colors.black
Colors.transparent

Colors.slate50 ... Colors.slate900
Colors.blue50 ... Colors.blue900
Colors.sky50 ... Colors.sky900
Colors.cyan50
Colors.cyan700
Colors.rose50
Colors.rose200
Colors.rose700
```

### Gradients

Use predefined gradients:

```dart
const DartStyle(gradient: Gradients.ocean)
const DartStyle(gradient: Gradients.sky)
const DartStyle(gradient: Gradients.softPanel)
```

Or build custom gradients:

```dart
DartStyle(
  gradient: Gradient.linear(135, const [
    GradientStop(Colors.sky500, 0),
    GradientStop(Colors.blue600, 58),
    GradientStop(Colors.blue700, 100),
  ]),
)
```

For evenly distributed colors:

```dart
DartStyle(
  gradient: Gradient.linearColors(135, const [
    Colors.blue600,
    Colors.sky500,
  ]),
)
```

### Flex

Use `Flex` helpers instead of raw CSS strings:

```dart
const DartStyle(
  display: Display.flex,
  flex: Flex.fill(),
)
```

Available helpers:

```dart
Flex.fill() // 1 1 auto
Flex.auto() // 1 1 auto
Flex.grow() // 1 1 0%
Flex.none() // 0 0 auto
Flex(2, 0, SizeValue.auto)
```

Individual properties are also available:

```dart
const DartStyle(
  flexGrow: 1,
  flexShrink: 0,
  flexBasis: SizeValue.auto,
)
```

### Responsive Styles

`DartStyle` supports responsive breakpoint overrides:

```dart
const DartStyle(
  width: SizeValue.full,
  padding: EdgeInsets.all(16),
  md: DartStyle(
    width: 520,
    padding: EdgeInsets.all(32),
  ),
  lg: DartStyle(
    width: 640,
  ),
)
```

Breakpoints:

```dart
sm: 640px
md: 768px
lg: 1024px
xl: 1280px
```

Responsive styles are compiled into scoped CSS rules by `mergeComponentProps`.

## Style Sheets

For reusable CSS classes, use `StyleSheet` and `StyleRule`:

```dart
const appStyles = StyleSheet(
  'app',
  {
    '.button': StyleRule({
      'background': Colors.blue600,
      'color': Colors.white,
      'border-radius': '8px',
    }, hover: {
      'background': Colors.blue700,
    }),
  },
);
```

Register stylesheets when the app starts:

```dart
createFlintApp(
  '#app',
  registry: componentRegistry,
  stylesheets: [appStyles],
);
```

Then use generated class names:

```dart
Button(
  className: appStyles.className('button'),
  child: 'Save',
)
```

## Component Catalog

### Primitives

```dart
Container
Row
Column
Text
Link
Image
Figure
```

### Actions

```dart
Button
ButtonGroup
IconButton
```

### Forms

```dart
Form
TextField
TextArea
Select
Checkbox
RadioGroup
Switch
FileInput
FieldGroup
TextEditingController
FormController
```

### Layout

```dart
AppShell
Grid
Section
Panel
PageHeader
Sidebar
Spacer
Stack
StatCard
Topbar
Wrap
Divider
EmptyState
```

### Data

```dart
Avatar
DataTable
DescriptionList
ProgressBar
Table
Timeline
UsageMeter
```

### Feedback

```dart
Alert
Spinner
StatusBadge
```

### Navigation

```dart
Breadcrumbs
Pagination
SearchBox
Tabs
```

### Overlays

```dart
ConfirmAction
Drawer
Modal
Popover
Skeleton
Toast
Tooltip
```

## Images

```dart
Image(
  src: '/images/avatar.png',
  alt: 'User avatar',
  width: 80,
  height: 80,
  loading: ImageLoading.lazy,
  decoding: ImageDecoding.async,
)
```

With a caption:

```dart
Figure(
  image: Image(
    src: '/images/server.png',
    alt: 'Server rack',
  ),
  caption: 'Primary hosting node',
)
```

## Navigation

Use the `navigation` singleton:

```dart
navigation.assign('/dashboard');
navigation.redirect('/login');
navigation.replace('/settings');
navigation.back();
navigation.reload();
```

Read the current URL:

```dart
currentUrl
currentPath
currentQuery
currentHash
currentUri
```

Example active sidebar:

```dart
Sidebar(
  items: const [
    SidebarItem(label: 'Overview', href: '/dashboard'),
    SidebarItem(label: 'Settings', href: '/dashboard/settings'),
  ],
  activePath: currentUri.path,
)
```

## Query Parameters

Use the `query` helper when you need to read or update browser query state without manually parsing `window.location.search`.

```dart
final tab = query.get('tab');

query.set('tab', 'billing');
query.update({
  'page': 2,
  'filter': 'active',
});
query.remove('filter');
```

## Browser Storage

Flint UI provides a small browser storage abstraction:

```dart
localStorage.write('theme', 'dark');
final theme = localStorage.read('theme');
localStorage.remove('theme');
```

Session storage:

```dart
sessionStorage.write('draft', 'hello');
```

Cookies:

```dart
cookies.write(
  'auth.token',
  token,
  maxAge: const Duration(days: 7),
  sameSite: CookieSameSite.lax,
);

final token = cookies.read('auth.token');
cookies.remove('auth.token');
```

## Auth Session

`AuthSessionManager` stores an auth token and user object in browser storage:

```dart
const authSession = AuthSessionManager(
  tokenKey: 'app.token',
  userKey: 'app.user',
);

authSession.save(
  token: token,
  user: {
    'id': 1,
    'email': 'admin@example.com',
    'role': 'admin',
  },
);

if (authSession.isLoggedIn) {
  navigation.assign('/dashboard');
}

authSession.clear();
```

By default it uses `localStorage`. You can provide another storage implementation:

```dart
const sessionAuth = AuthSessionManager(
  storage: sessionStorage,
);
```

## HTTP Client

Use `clientRouter` to call FlintDart APIs from the browser:

```dart
final response = await clientRouter.group('/auth').post<Map<String, dynamic>>(
  '/login',
  body: {
    'email': email,
    'password': password,
  },
);

if (response.isError) {
  throw response.error!;
}

final data = response.data;
```

When running in the browser, `ClientRouter` defaults to the current browser origin if no base URL is provided.

## Environment Config

Use `EnvironmentConfig` for browser-side configuration:

```dart
final apiBase = env.get('API_BASE_URL', fallback: '/api');
```

This is useful when the server injects public configuration into the page.

## FlintDart Integration

A typical FlintDart fullstack UI route looks like this:

```dart
class UiController {
  Response login(Request req, Response res) {
    return res.page(
      'Login',
      title: 'Login',
      script: '/main.dart.js',
      props: {
        'authBase': '/auth',
      },
    );
  }
}
```

And the browser entrypoint:

```dart
void main() {
  createFlintApp(
    '#app',
    registry: FlintComponentRegistry({
      'Login': (props) => LoginPage(props),
      'Dashboard': (props) => DashboardPage(props),
    }),
  );
}
```

## Development

Install dependencies:

```bash
dart pub get
```

Run tests:

```bash
dart test -p chrome
```

Run focused tests:

```bash
dart test test/style_test.dart -p chrome
dart test test/widgets_test.dart -p chrome
```

Analyze:

```bash
dart analyze
```

Format:

```bash
dart format lib test
```

## Package Structure

```text
lib/
  flint_ui.dart              # Full public export
  flint_ui_core.dart         # Core public export
  src/
    auth/                    # Auth session helpers
    client/                  # Browser API client
    config/                  # Browser environment config
    navigation/              # Browser navigation/query helpers
    storage/                 # localStorage/sessionStorage/cookies
    style.dart               # Style public entrypoint
    style/                   # Split style modules
    widgets/                 # Component library
```

## Design Direction For V1

Flint UI v1 should make it possible to build production admin apps, dashboards, auth flows, forms, and operational tools with Dart-first components.

Priority areas:

```text
Typed style system
Responsive layout primitives
Core form controls
Feedback and loading states
Tables and data views
App shells and navigation
Better examples and docs
Stable FlintDart fullstack workflow
```

## License

MIT
