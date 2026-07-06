# Flint UI

`flint_ui` is a Dart-first web UI layer for Flint fullstack applications. It gives you a small component model, browser rendering, page mounting, typed style helpers, browser storage, navigation utilities, and a growing set of application components.

The goal is simple: build real FlintDart web interfaces in Dart without reaching for raw HTML, JavaScript, and CSS strings for every screen.

## Status

Flint UI is pre-1.0 and actively evolving. The current package is suitable for building FlintDart app UIs and internal dashboards, but APIs may still change while the v1 surface is shaped.

## Install

Add `flint_ui` to your app:

```yaml
dependencies:
  flint_ui: ^0.1.12
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

Create a Flint UI entry file, usually `lib/ui/main.dart`:

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
    props: {
      'name': 'Flint',
    },
  );
}
```

Compile the UI:

```bash
dart compile js lib/ui/main.dart -o public/main.dart.js
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

Theme mode is state too, so you can place a switch beside or after a counter:

```dart
class ThemeModeToggle extends FlintComponent {
  @override
  FlintNode build() {
    return StateSignalListener(flintTheme.mode, (mode) {
      final isDark = mode == FlintThemeMode.dark;

      return Container(
        dartStyle: DartStyle(
          padding: const EdgeInsets.all(16),
          radius: ThemeToken.radius('md'),
          background: ThemeToken.color('surface'),
          color: ThemeToken.color('text'),
          light: DartStyle(border: Border.all(color: Colors.slate200)),
          dark: DartStyle(shadow: ThemeToken.shadow('card')),
        ),
        children: [
          Text.span(isDark ? 'Dark mode' : 'Light mode'),
          Button(
            child: isDark ? 'Use light' : 'Use dark',
            onPressed: (_) => flintTheme.toggle(),
          ),
        ],
      );
    });
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
  View  build() => Text('Example');
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

Configure app-wide theme tokens once at startup:

```dart
createFlintApp(
  '#app',
  registry: componentRegistry,
  themeMode: FlintThemeMode.dark,
);
```

Then use semantic tokens anywhere:

```dart
Container(
  dartStyle: DartStyle(
    background: ThemeToken.color('surface'),
    color: ThemeToken.color('text'),
    radius: ThemeToken.radius('md'),
    light: DartStyle(
      border: Border.all(color: ThemeToken.color('surfaceBorder')),
    ),
    dark: DartStyle(
      shadow: ThemeToken.shadow('card'),
    ),
  ),
)
```

Use `ThemeProvider` only when a subtree needs to override the global mode:

```dart
ThemeProvider(
  mode: FlintThemeMode.light,
  child: SettingsPreview(),
)
```

Switch the global theme from UI state with `flintTheme`:

```dart
StateSignalListener(flintTheme.mode, (mode) {
  return Button(
    child: mode == FlintThemeMode.dark ? 'Light mode' : 'Dark mode',
    onPressed: (_) => flintTheme.toggle(),
  );
})
```

The selected mode is stored in local storage by default. On page load Flint
uses the saved mode first, then the system color scheme, then the app default.

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

These are the main public component groups exported by `package:flint_ui/flint_ui.dart`.

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

### Icons

```dart
Icon(Icons.home)
Icon(Icons.search, label: 'Search')
Icon(Icons.server, size: 24, color: Colors.blue600)
Icons.all
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

## Data Fetching With FlintDart

Flint UI is designed to pair with FlintDart in two phases:

1. Render the first screen from FlintDart with `res.page(..., props: {...})`.
2. Refresh and mutate browser data with `ResourceController` and `FlintModelApi`.

This gives you fast first paint, predictable state, and live UI updates without hand-writing fetch boilerplate in every component.

### Server Props First

Use FlintDart models on the server, then pass plain JSON props to the browser:

```dart
Future<Response> dashboard(Request req, Response res) async {
  final plans = await Plan().all();

  return res.page(
    'Dashboard',
    title: 'Dashboard',
    script: '/main.dart.js',
    props: {
      'plans': plans.map((plan) => plan.toMap()).toList(),
    },
  );
}
```

### Resource State In The Browser

Use a resource when data can load, refresh, fail, or be locally mutated:

```dart
class PlansPanel extends FlintComponent {
  PlansPanel(List<Map<String, dynamic>> initialPlans) {
    plans = ResourceController<List<FlintModelRecord>>(
      initialData: initialPlans.map(FlintModelRecord.new).toList(),
      loader: () => FlintModelApi<FlintModelRecord>
          .records('/plans')
          .list(),
      loadImmediately: true,
    );
  }

  late final ResourceController<List<FlintModelRecord>> plans;

  @override
  void willUnmount() {
    plans.dispose();
  }

  @override
  FlintNode build() {
    return ResourceView<List<FlintModelRecord>>(
      plans,
      (snapshot) {
        final rows = snapshot.data ?? const <FlintModelRecord>[];

        if (snapshot.isLoading && rows.isEmpty) {
          return DataTable(columns: columns, loading: true);
        }

        if (snapshot.isError && rows.isEmpty) {
          return EmptyState(
            title: 'Could not load plans',
            message: snapshot.error.toString(),
          );
        }

        return Column(children: [
          Button(
            child: 'Refresh',
            onPressed: (_) => plans.refresh(silent: true),
          ),
          DataTable(
            columns: columns,
            rows: [
              for (final plan in rows)
                TableRowData(cells: {
                  'name': plan.string('name') ?? 'Plan',
                  'price': plan.string('price') ?? '0',
                }),
            ],
          ),
        ]);
      },
    );
  }
}
```

`ResourceController<T>` stores:

```text
status     idle | loading | success | error
data       the latest successful value
error      the latest error
updatedAt  when data/error last changed
```

Use `refresh(silent: true)` when you want to keep existing data visible while the next request runs.

### Can Flint UI Use FlintDart Models Directly?

Not directly in browser code. Server-side FlintDart `Model` classes depend on database and server APIs, so they should stay on the server.

The recommended bridge is:

```text
FlintDart Model -> toMap()/JSON -> Flint UI DTO/FlintModelRecord
```

For quick dashboards, use `FlintModelRecord`:

```dart
final api = FlintModelApi<FlintModelRecord>.records('/users');
final users = await api.list();
final email = users.first.string('email');
```

For larger apps, create typed client DTOs:

```dart
class PlanDto {
  PlanDto.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'].toString(),
        price = double.tryParse(json['price']?.toString() ?? '') ?? 0;

  final String id;
  final String name;
  final double price;
}

final plansApi = FlintModelApi<PlanDto>(
  path: '/plans',
  fromJson: PlanDto.fromJson,
);
```

## State Management

Flint UI has three practical state layers:

```text
setState          component-local state
StateSignal<T>    shared reactive value
ResourceController<T> API data with loading/error/cache state
```

### Component State

Use `setState` for state owned by one component:

```dart
class Counter extends FlintComponent {
  int count = 0;

  @override
  FlintNode build() {
    return Button(
      child: 'Count: $count',
      onPressed: (_) => setState(() => count++),
    );
  }
}
```

### Shared State

Use `StateSignal<T>` when multiple components need the same value:

```dart
final sidebarOpen = StateSignal<bool>(true);

StateSignalListener<bool>(
  sidebarOpen,
  (open) => Text(open ? 'Open' : 'Closed'),
);
```

### API State

Use `ResourceController<T>` for data fetched from FlintDart:

```dart
final users = ResourceController<List<FlintModelRecord>>(
  loader: () => FlintModelApi<FlintModelRecord>.records('/users').list(),
);

await users.load();
```

### One-Way Or Two-Way?

Flint UI's recommended architecture is **one-way data flow**:

```text
server props/API data -> state/resource -> build() -> DOM
user event -> setState/resource mutation -> build() -> DOM
```

Form controls can feel like two-way binding because `TextEditingController` and `FormController` keep input fields synchronized with form state. Under the hood, that is still controlled state: user input updates the controller, the controller notifies listeners, and the component rerenders from the new value.

For complex apps, prefer one-way state for pages and resources, and use controlled form fields for editing.

A complete source example lives at `example/resource_dashboard.dart`. It shows:

```text
server props -> ResourceController initialData
GET /plans -> FlintModelApi refresh
FormController -> controlled input state
ResourceController.mutate -> local UI update
ResourceView -> loading/error/cached-data rendering
```

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

Generate API documentation:

```bash
dart doc
```

The generated API reference is written to `doc/api/index.html`.

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
