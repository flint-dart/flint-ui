# Flint Web UI Component Adoption Plan

This document lists the components Flint Web UI should add so EuPanel and the rest of the Eulogia ecosystem can build fullstack dashboards without Next.js or React.

For the step-by-step implementation order, see `component_plan.md`.

## Current Flint Web UI Base

Flint Web UI currently gives us the foundation:

- `FlintComponent` with `setState`, lifecycle hooks, and `build()`.
- `Head` for adding document `<head>` tags like CDN scripts, stylesheets, meta tags, and page titles from Flint UI code.
- Low-level HTML helpers: `h`, `div`, `span`, `button`, `input`, `text`, `fragment`, `component`.
- Layout primitives: `Container`, `Row`, `Column`.
- Basic `Button`.
- Page registry and app boot through `FlintComponentRegistry` and `createFlintApp`.

That is enough for first pages, but not enough for a production admin panel. The next layer should be reusable form, navigation, table, overlay, and feedback components.

## Head Component

Use `Head` when an app needs to add global browser assets or metadata from Flint UI code. This keeps Tailwind CDN links, external stylesheets, font links, meta tags, and page titles close to the page or shell that needs them.

```dart
import 'package:flint_ui/flint_ui.dart';

class LoginPage extends FlintComponent {
  @override
  FlintNode build() {
    return fragment([
      Head(
        title: 'Login',
        tags: [
          Head.meta(charset: 'utf-8'),
          Head.meta(
            name: 'viewport',
            content: 'width=device-width, initial-scale=1',
          ),
          Head.script(src: 'https://cdn.tailwindcss.com'),
          Head.link(
            href: 'https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&display=swap',
          ),
        ],
      ),
      div(children: ['Login page content']),
    ]);
  }
}
```

Compiled CSS is still supported through `flint_ui/tailwind.css`, but Tailwind is optional. If the standalone Tailwind binary is not available, Flint can keep running and the app may rely on a `Head.script(src: 'https://cdn.tailwindcss.com')` tag or any stylesheet link the user provides.

For SEO-critical pages, also pass metadata from the server route so crawlers receive tags in the initial HTML response:

```dart
app.get('/dashboard', (req, res) {
  return res.flintPage(
    'Dashboard',
    meta: const FlintPageMeta(
      title: 'EuPanel Dashboard',
      description: 'Manage hosting, domains, billing, and users.',
      canonicalUrl: 'https://eupanel.example/dashboard',
      imageUrl: 'https://eupanel.example/og.png',
      siteName: 'EuPanel',
    ),
  );
});
```

## Naming Convention

Use the `Flint` prefix for framework-level classes only:

- `FlintComponent`
- `FlintNode`
- `FlintElement`
- `FlintFragment`
- `FlintText`
- `FlintComponentRegistry`

Do not use the `Flint` prefix for normal UI components. A Flint web project should feel natural after importing `package:flint_ui/flint_ui.dart`, so application code should read like:

```dart
AppShell(
  sidebar: Sidebar(...),
  children: [
    PageHeader(title: 'Users'),
    DataTable(...),
    Checkbox(label: 'Active'),
  ],
)
```

If a short name conflicts with a Dart or browser concept, choose the clearest UI name instead of adding `Flint`. For example, prefer `DataTable` over `Table`, `TextInput` over a confusing field name if needed, and `Panel` only when it represents a real framed tool area.

## Priority 1: Form Controls

These unlock login, provisioning forms, plan forms, server settings, tenant settings, and user management.

| Component | Why We Need It | Key Props / Behavior |
|---|---|---|
| `TextField` | Standard text, email, password, URL, number inputs. | `label`, `name`, `value`, `placeholder`, `type`, `required`, `disabled`, `error`, `helpText`, `onChanged` |
| `TextArea` | Notes, DNS TXT values, deployment scripts, descriptions. | `label`, `name`, `value`, `rows`, `error`, `onChanged` |
| `Checkbox` | Permissions, feature flags, plan capabilities, bulk selections. | `label`, `checked`, `disabled`, `indeterminate`, `onChanged` |
| `Switch` | On/off settings like active, suspended, auto-renew, SSL enabled. | `label`, `checked`, `disabled`, `onChanged` |
| `RadioGroup` | Mutually exclusive choices like billing cycle, runtime type. | `label`, `options`, `value`, `onChanged` |
| `Select` | Plans, roles, servers, domains, runtimes, status filters. | `label`, `options`, `value`, `placeholder`, `searchable`, `onChanged` |
| `DatePicker` | Subscription dates, certificate expiry, backups, reports. | `label`, `value`, `min`, `max`, `onChanged` |
| `FileInput` | SSL certificate upload, import files, backups. | `label`, `accept`, `multiple`, `onChanged` |
| `Form` | Consistent submit handling and validation surfaces. | `onSubmit`, `loading`, `disabled`, `children` |
| `FieldGroup` | Groups related fields cleanly in settings pages. | `title`, `description`, `children` |

## Priority 2: Buttons and Actions

These make destructive and operational actions predictable.

| Component | Why We Need It | Key Props / Behavior |
|---|---|---|
| `Button` | Replace the basic button with variants and loading state. | `variant`, `size`, `loading`, `disabled`, `icon`, `onPressed` |
| `IconButton` | Compact dashboard actions. | `icon`, `label`, `tooltip`, `variant`, `onPressed` |
| `ButtonGroup` | Group view/edit/delete/refresh actions. | `children`, `align` |
| `DropdownMenu` | Row actions, account menu, module actions. | `items`, `trigger`, `onSelect` |
| `ConfirmAction` | Deactivate user, delete domain, terminate subscription. | `title`, `message`, `confirmLabel`, `danger`, `onConfirm` |

## Priority 3: Dashboard Layout

EuPanel, Eulogia Website/Platform, StuCoach, SchoolHQ, and HospitalHQ all need this pattern.

| Component | Why We Need It | Key Props / Behavior |
|---|---|---|
| `AppShell` | Standard admin layout with sidebar and main area. | `brand`, `sidebar`, `topbar`, `children` |
| `Sidebar` | Role-aware navigation. | `items`, `activePath`, `collapsed`, `onToggle` |
| `Topbar` | Page title, search, user menu, notifications. | `title`, `subtitle`, `actions`, `user` |
| `PageHeader` | Consistent page title and command area. | `title`, `description`, `actions`, `breadcrumbs` |
| `Section` | Unframed content sections. | `title`, `description`, `actions`, `children` |
| `Panel` | Framed tool areas where a card is appropriate. | `title`, `description`, `actions`, `children` |
| `StatCard` | Metrics like users, tenants, plans, active subscriptions. | `label`, `value`, `trend`, `tone`, `icon` |
| `ModuleCard` | Product/module overview tiles. | `title`, `description`, `href`, `status`, `metric` |
| `EmptyState` | Clean empty lists and first-run states. | `title`, `message`, `action` |

## Priority 4: Data Display

This is required for users, tenants/schools, students, hosting products, VPS, shared hosting, subscriptions, domains, jobs, and audit logs.

| Component | Why We Need It | Key Props / Behavior |
|---|---|---|
| `Table` | Main reusable table component. | `columns`, `rows`, `rowKey`, `loading`, `emptyState`, `onRowClick` |
| `DataTable` | Table with sorting, filtering, pagination, and bulk selection. | `columns`, `rows`, `sort`, `filters`, `pagination`, `selectedRows` |
| `StatusBadge` | Active, suspended, pending, failed, expired. | `label`, `tone`, `icon` |
| `Avatar` | Users, students, school owners, admins. | `name`, `imageUrl`, `size` |
| `DescriptionList` | Detail pages for server/user/subscription metadata. | `items` |
| `Timeline` | Jobs, deployments, audits, lifecycle events. | `items`, `density` |
| `ProgressBar` | Disk, bandwidth, quota, job progress. | `value`, `max`, `label`, `tone` |
| `UsageMeter` | Hosting resource usage cards. | `label`, `used`, `limit`, `unit`, `tone` |

## Priority 5: Navigation

These make larger control panels feel coherent.

| Component | Why We Need It | Key Props / Behavior |
|---|---|---|
| `Tabs` | Split overview, users, billing, settings, logs. | `tabs`, `activeKey`, `onChanged` |
| `Breadcrumbs` | Deep resources like school -> class -> student. | `items` |
| `Pagination` | Long users, tenants, jobs, logs lists. | `page`, `pageSize`, `total`, `onChanged` |
| `SearchBox` | Global and table search. | `value`, `placeholder`, `onChanged`, `onSubmit` |
| `CommandPalette` | Fast admin navigation and actions. | `groups`, `open`, `onSelect` |

## Priority 6: Overlays and Feedback

These are needed before sensitive admin actions feel safe.

| Component | Why We Need It | Key Props / Behavior |
|---|---|---|
| `Modal` | Create/edit forms and focused workflows. | `open`, `title`, `size`, `onClose`, `children` |
| `Drawer` | Side detail panels for users, subscriptions, jobs. | `open`, `side`, `title`, `onClose`, `children` |
| `Toast` | Success/error feedback after API actions. | `title`, `message`, `tone`, `duration` |
| `Alert` | Inline warning, error, info, success messages. | `title`, `message`, `tone`, `actions` |
| `Tooltip` | Icon button explanations and dense tables. | `content`, `child`, `placement` |
| `Popover` | Filters, quick info, mini forms. | `trigger`, `children`, `placement` |
| `Skeleton` | Loading states for cards and tables. | `shape`, `lines`, `width`, `height` |
| `Spinner` | Small loading indicators. | `size`, `label` |

## Priority 7: Product-Specific EuPanel Components

These can live in EuPanel first. If they become useful across projects, move them into Flint Web UI later.

| Component | Why We Need It |
|---|---|
| `ProductOverviewGrid` | Count and display Shared Hosting, VPS, domains, SSL, databases, backups, email, and future products. |
| `TenantOverviewTable` | Show schools/tenants, owners, students, users, subscriptions, and status. |
| `UserAccessTable` | Activate/deactivate users across EuPanel, StuCoach, SchoolHQ, and related products. |
| `SubscriptionResourcePanel` | Show usage, plan limits, renewal state, and provisioning status. |
| `ProvisioningJobList` | Surface pending/failed/successful server work. |
| `ServerHealthPanel` | Show connected VPS/agents, heartbeat, disk, memory, and service status. |
| `AuditLogPanel` | Show who changed a user, tenant, subscription, or server setting. |

## Dart Styling Model

Flint Web UI should support component styling directly from Dart while still allowing normal CSS classes. The best model is layered:

1. Every component accepts `props`.
2. Every visual component accepts `className`.
3. Every visual component accepts `style` as `Map<String, Object?>`.
4. Every app can define reusable Dart `StyleSheet` objects.
5. Components merge default styles, variant styles, state styles, and user styles in that order.
6. Product apps can still use external CSS files when they want global styling.

### StyleSheet Object

Flint should add a Dart stylesheet object so projects can write reusable CSS-like rules without leaving Dart.

Example:

```dart
final dashboardStyles = StyleSheet('dashboard', {
  '.shell': StyleRule({
    'display': 'grid',
    'grid-template-columns': '260px minmax(0, 1fr)',
    'min-height': '100vh',
    'background': '#f7f8fb',
  }),
  '.sidebar': StyleRule({
    'background': '#101828',
    'color': '#fff',
    'padding': '20px',
  }),
  '.navLink': StyleRule({
    'display': 'flex',
    'align-items': 'center',
    'gap': '8px',
    'border-radius': '6px',
    'padding': '8px 10px',
  }, hover: {
    'background': 'rgba(255,255,255,0.08)',
  }),
  '@media (max-width: 760px)': StyleRule.nested({
    '.shell': {
      'grid-template-columns': '1fr',
    },
    '.sidebar': {
      'display': 'none',
    },
  }),
});
```

Then the app can register it:

```dart
void main() {
  createFlintApp(
    '#app',
    registry: componentRegistry,
    stylesheets: [dashboardStyles],
  );
}
```

And components can use generated class names:

```dart
Container(
  props: {'className': dashboardStyles.className('shell')},
  children: [
    Sidebar(className: dashboardStyles.className('sidebar')),
  ],
)
```

The generated CSS should be injected into the document head once:

```css
.dashboard-shell { ... }
.dashboard-sidebar { ... }
.dashboard-navLink:hover { ... }
@media (max-width: 760px) {
  .dashboard-shell { ... }
  .dashboard-sidebar { ... }
}
```

### Proposed StyleSheet API

| API | Purpose |
|---|---|
| `StyleSheet(name, rules)` | Creates a named stylesheet namespace. |
| `StyleRule(styles)` | Creates one CSS rule from a Dart map. |
| `StyleRule.nested(rules)` | Creates nested rules for media queries. |
| `stylesheet.className(key)` | Returns the generated safe class name. |
| `stylesheet.cssText` | Returns compiled CSS text. |
| `registerStyleSheet(stylesheet)` | Injects a stylesheet into the current page. |
| `createFlintApp(..., stylesheets: [])` | Registers app styles on boot. |

### StyleRule States

Style rules should support common pseudo states from Dart:

```dart
StyleRule(
  {
    'background': '#fff',
    'border': '1px solid #d0d5dd',
  },
  hover: {
    'border-color': '#667085',
  },
  focus: {
    'outline': '2px solid #84caff',
  },
  disabled: {
    'opacity': 0.5,
    'pointer-events': 'none',
  },
)
```

Supported states should include:

- `hover`
- `focus`
- `focusVisible`
- `active`
- `disabled`
- `checked`
- `selected`
- `expanded`
- `invalid`

### Theme Tokens

StyleSheet should also work with theme tokens so Eulogia products can share a design language:

```dart
final theme = ThemeTokens({
  'color.primary': '#155eef',
  'color.danger': '#d92d20',
  'radius.sm': '6px',
  'space.2': '8px',
});

final styles = StyleSheet('button', {
  '.primary': StyleRule({
    'background': token('color.primary'),
    'border-radius': token('radius.sm'),
    'padding': '${token('space.2')} 12px',
  }),
}, tokens: theme);
```

The compiler should resolve tokens before CSS injection.

### Why This Matters

A Dart stylesheet object gives Flint Web UI:

- Reusable component styles.
- A clean path for themes.
- Less repeated inline style code.
- Better support for hover/focus/media queries.
- Better adoption for teams who want one Dart fullstack workflow.
- A way to ship default component styles without requiring Tailwind, Bootstrap, or a separate CSS build step.

### One DartStyle Object

Flint Web UI should use one web-focused `DartStyle` object for component design instead of adding many Flutter-style properties to every component. This keeps Flint simple, consistent, and easier to maintain.

The goal is not to recreate Flutter. The goal is to make web CSS comfortable to write from Dart.

Example:

```dart
Container(
  dartStyle: DartStyle(
    padding: EdgeInsets.all(16),
    margin: EdgeInsets.only(bottom: 12),
    width: 320,
    display: Display.flex,
    gap: 12,
    alignItems: AlignItems.center,
    background: Colors.white,
    radius: 8,
    border: Border.all(color: '#d0d5dd'),
  ),
  child: Text('Hosting plan'),
)
```

The component compiles those Dart properties into CSS:

```css
padding: 16px;
margin-bottom: 12px;
width: 320px;
display: flex;
gap: 12px;
align-items: center;
background: #fff;
border-radius: 8px;
border: 1px solid #d0d5dd;
```

Every visual component should support the same styling entry points:

| Prop | Purpose |
|---|---|
| `dartStyle` | Main typed Dart style object for layout, sizing, spacing, positioning, text, background, border, radius, and shadow. |
| `className` | Product or theme CSS hook. |
| `style` | Raw CSS map escape hatch. |
| `props` | Low-level HTML props escape hatch. |

Recommended supporting objects:

| Object | Purpose |
|---|---|
| `DartStyle` | Main style class. Compiles to a CSS map. |
| `EdgeInsets` | Padding and margin values. |
| `SizeValue` | CSS sizes like px, %, rem, em, auto, full. |
| `Border` | Border width, color, and style. |
| `Shadow` | CSS box shadows. |
| `Colors` | Common color constants and helpers. |

`DartStyle` should cover common web layout, text, and visual design needs:

| DartStyle Field | CSS Output |
|---|---|
| `padding` | `padding` |
| `margin` | `margin` |
| `width`, `height` | `width`, `height` |
| `minWidth`, `maxWidth` | `min-width`, `max-width` |
| `minHeight`, `maxHeight` | `min-height`, `max-height` |
| `display` | `display` |
| `gap` | `gap` |
| `alignItems` | `align-items` |
| `justifyContent` | `justify-content` |
| `flexDirection` | `flex-direction` |
| `flexWrap` | `flex-wrap` |
| `gridTemplateColumns` | `grid-template-columns` |
| `position` | `position` |
| `top`, `right`, `bottom`, `left` | position offsets |
| `zIndex` | `z-index` |
| `overflow` | `overflow` |
| `fontSize`, `fontWeight`, `lineHeight` | text sizing |
| `color` | `color` |
| `textAlign` | `text-align` |
| `cursor` | `cursor` |
| `background` | `background` |
| `radius` | `border-radius` |
| `border` | `border` |
| `shadow` | `box-shadow` |
| `opacity` | `opacity` |
| `gradient` | `background` |

`DartStyle` should be optional and merged into the final `style` map before rendering:

```dart
Container(
  dartStyle: DartStyle(
    padding: EdgeInsets.all(16),
    background: '#fff',
  ),
  style: {
    'backdrop-filter': 'blur(8px)',
  },
)
```

Merge order:

1. Component defaults.
2. Variant, size, tone, and state styles.
3. `dartStyle`.
4. Explicit `style` map.
5. Explicit `props['style']`.

That means a user can start with one clean Dart style object, then override anything with raw CSS when needed.

Initial API target:

```dart
Container({
  Object? child,
  List<Object?> children = const [],
  String? className,
  Map<String, Object?> props = const {},
  Map<String, Object?> style = const {},
  DartStyle? dartStyle,
});

Row({
  Object? child,
  List<Object?> children = const [],
  String? className,
  Map<String, Object?> props = const {},
  Map<String, Object?> style = const {},
  DartStyle? dartStyle,
});

Column({
  Object? child,
  List<Object?> children = const [],
  String? className,
  Map<String, Object?> props = const {},
  Map<String, Object?> style = const {},
  DartStyle? dartStyle,
});
```

Example usage:

```dart
Button(
  variant: ButtonVariant.primary,
  size: ButtonSize.sm,
  style: {
    'min-width': '120px',
    'justify-content': 'center',
  },
  onPressed: (_) {},
  child: Text('Save'),
)
```

Component constructors should follow this shape:

```dart
class Checkbox extends FlintElement {
  Checkbox({
    String? label,
    bool checked = false,
    bool disabled = false,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    void Function(bool checked)? onChanged,
  }) : super(
          'label',
          props: mergeComponentProps(
            props,
            className: className,
            style: style,
          ),
          children: [
            input(props: {
              'type': 'checkbox',
              'checked': checked,
              'disabled': disabled,
              if (onChanged != null) 'onChange': onChanged,
            }),
            if (label != null) Text(label),
          ],
        );
}
```

The shared style helper should live in Flint Web UI:

```dart
Map<String, Object?> mergeComponentProps(
  Map<String, Object?> props, {
  String? className,
  Map<String, Object?> style = const {},
}) {
  final existingClass = props['className']?.toString();
  final existingStyle = props['style'];

  return {
    ...props,
    if (className != null || existingClass != null)
      'className': [
        if (existingClass != null && existingClass.isNotEmpty) existingClass,
        if (className != null && className.isNotEmpty) className,
      ].join(' '),
    if (style.isNotEmpty)
      'style': switch (existingStyle) {
        Map<String, Object?> existing => {...existing, ...style},
        String existing => '$existing; ${styleToCss(style)}',
        _ => style,
      },
  };
}
```

Recommended style APIs:

| API | Purpose |
|---|---|
| `style` | Inline Dart style map for one-off styling. |
| `className` | Product or theme CSS hook. |
| `variant` | Component visual role, like primary, secondary, danger, ghost. |
| `size` | Component density, like sm, md, lg. |
| `tone` | Semantic color, like neutral, success, warning, danger, info. |
| `disabled` | Disabled visual and behavior state. |
| `loading` | Loading visual and behavior state. |

Style rules:

- Prefer component props like `variant`, `size`, and `tone` for repeated styling.
- Use `style` for local one-off overrides.
- Use `className` for product theme hooks and larger CSS layouts.
- Keep default component styles minimal and predictable.
- Do not require a CSS framework for Flint Web UI components to work.
- Do not hide important layout behavior inside global CSS only; core components should render usable HTML by default.

## Implementation Order

1. Add form controls: `TextField`, `Checkbox`, `Switch`, `Select`.
2. Add action components: `Button`, `IconButton`, `ConfirmAction`.
3. Add layout components: `AppShell`, `Sidebar`, `Topbar`, `PageHeader`, `StatCard`.
4. Add data components: `Table`, `StatusBadge`, `EmptyState`.
5. Add overlays and feedback: `Modal`, `Alert`, `Toast`, `Skeleton`.
6. Use those components inside EuPanel dashboard pages.
7. Move repeated EuPanel patterns back into Flint Web UI when at least two Eulogia products need them.

## Adoption Rules

- Components should render plain HTML through Flint Web UI primitives.
- Components should accept `className`, `style`, and `props` so each product can style them from Dart or CSS.
- Components should support loading, disabled, empty, and error states where relevant.
- Destructive actions must use confirmation UI.
- Form components must expose consistent `name`, `value`, `error`, `helpText`, and `onChanged`.
- Table components must support row actions and bulk selection because admin panels need them constantly.
- Product-specific components should start in the product app, then graduate into Flint when reused.

