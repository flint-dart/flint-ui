# Flint UI Component Implementation Plan

This is the build plan for finishing the component work described in `component.md`.

The order matters. Flint UI should first get a small styling foundation, then use that foundation to build each component family consistently.

## Goal

Build a production-ready Flint UI component layer that can power EuPanel and other Eulogia apps without requiring React, Next.js, Bootstrap, or Tailwind.

Every component should:

- Render plain, accessible HTML through Flint UI primitives.
- Work with no external CSS framework.
- Accept `className`, `style`, `dartStyle`, and `props`.
- Support predictable variants, sizes, tones, disabled/loading/error states where relevant.
- Stay small enough that product apps can override or extend it.

## File Organization

Each component or widget gets one implementation file in `lib/src/widgets/`.

Examples:

- `lib/src/widgets/primitives/container.dart`
- `lib/src/widgets/actions/button.dart`
- `lib/src/widgets/feedback/alert.dart`
- `lib/src/widgets/forms/text_field.dart`
- `lib/src/widgets/data/data_table.dart`

Current folders:

- `primitives`: `Text`, `Container`, `Row`, `Column`
- `actions`: `Button`, `IconButton`, `ButtonGroup`
- `feedback`: `Spinner`, `Alert`, `StatusBadge`
- `shared`: widget enums and shared visual style helpers

Future component families should add folders such as `forms`, `layout`, `data`, `navigation`, and `overlays`. The folder barrel is `lib/src/widgets/widgets.dart`, and the compatibility barrel `lib/src/widgets.dart` re-exports that folder. Public app code should continue importing `package:flint_ui/flint_ui.dart` or `package:flint_ui/flint_ui_core.dart`.

## Phase 1: Styling Foundation

This is the first thing to implement.

Status: implemented.

### 1. Add `DartStyle`

Create `lib/src/style.dart`.

Core API:

```dart
Container(
  dartStyle: DartStyle(
    padding: EdgeInsets.all(16),
    display: Display.flex,
    gap: 12,
    background: '#fff',
    radius: 8,
  ),
)
```

Initial classes and enums:

- `DartStyle`
- `EdgeInsets`
- `SizeValue`
- `Border`
- `Shadow`
- `Display`
- `FlexDirection`
- `AlignItems`
- `JustifyContent`
- `Position`
- `TextAlign`

`DartStyle.toMap()` should compile to the same `Map<String, Object?>` style format the renderer already supports.

### 2. Add Shared Component Helpers

Create `lib/src/component_props.dart`.

Needed helpers:

- `mergeComponentProps(...)`
- `mergeStyles(...)`
- `normalizeChildren(...)`
- `joinClassNames(...)`
- `styleToCss(...)`

Merge order:

1. Component default style.
2. Variant, size, tone, and state style.
3. `dartStyle`.
4. Explicit `style`.
5. Explicit `props['style']`.

This keeps component behavior predictable and gives users a final escape hatch.

### 3. Update Existing Primitives

Update:

- `Container`
- `Row`
- `Column`
- `Button`
- HTML helpers where useful

Target constructor shape:

```dart
Container({
  Object? child,
  List<Object?> children = const [],
  String? className,
  Map<String, Object?> props = const {},
  Map<String, Object?> style = const {},
  DartStyle? dartStyle,
});
```

Keep backwards compatibility with existing `props`, `style`, `child`, and `children`.

### 4. Tests

Add tests for:

- `DartStyle.toMap()`
- `EdgeInsets` CSS output
- `mergeComponentProps()` class merging
- style merge order
- existing widgets still render the same node structure

## Phase 2: Better Button and Basic Feedback

Build a better `Button` before form controls, because forms and modals need it.

Status: implemented.

### Components

- `Button`
- `IconButton`
- `ButtonGroup`
- `Spinner`
- `Alert`
- `StatusBadge`

### Button API

```dart
Button(
  variant: ButtonVariant.primary,
  size: ButtonSize.md,
  tone: Tone.neutral,
  loading: false,
  disabled: false,
  onPressed: (_) {},
  child: Text('Save'),
)
```

Initial shared enums:

- `Tone`: `neutral`, `primary`, `success`, `warning`, `danger`, `info`
- `ComponentSize`: `xs`, `sm`, `md`, `lg`

## Phase 3: Form Controls

These unlock useful app screens quickly.

Status: implemented.

### Components

- `TextField`
- `TextArea`
- `Checkbox`
- `Switch`
- `RadioGroup`
- `Select`
- `FileInput`
- `Form`
- `FieldGroup`

### Required Behavior

Every field should support:

- `label`
- `name`
- `value`
- `disabled`
- `required`
- `error`
- `helpText`
- `onChanged`
- `onValidated`

Accessibility:

- Labels must connect to inputs.
- Errors should be connected with `aria-describedby`.
- Disabled/required state should map to real HTML attributes.

## Phase 4: Layout Components

These make EuPanel-style admin pages possible.

Status: implemented.

### Components

- `AppShell`
- `Sidebar`
- `Topbar`
- `PageHeader`
- `Section`
- `Panel`
- `StatCard`
- `EmptyState`

### Rule

Keep operational apps quiet and useful. Avoid marketing-style hero layouts inside dashboards.

## Phase 4b: Layout Primitives

These make dashboard, form, and data-display layouts easier without writing repeated style maps.

Status: implemented.

### Components

- `Grid`
- `Wrap`
- `Stack`
- `Spacer`
- `Divider`

## Phase 5: Data Display

Build the reusable pieces needed for users, tenants, subscriptions, servers, jobs, and logs.

Status: implemented.

### Components

- `Table`
- `DataTable`
- `Avatar`
- `DescriptionList`
- `Timeline`
- `ProgressBar`
- `UsageMeter`

### DataTable First Version

Support:

- columns
- rows
- empty state
- loading state
- row click
- row actions

Sorting, pagination, filters, and bulk selection can come after the first stable table.

## Phase 6: Navigation

Status: implemented.

### Components

- `Tabs`
- `Breadcrumbs`
- `Pagination`
- `SearchBox`

Leave `CommandPalette` for later because it needs keyboard focus management and overlay behavior.

## Phase 7: Overlays

Status: implemented.

### Components

- `Modal`
- `Drawer`
- `Tooltip`
- `Popover`
- `Toast`
- `Skeleton`
- `ConfirmAction`

### Required Behavior

Before this phase, add enough renderer support for:

- document-level event listeners if needed
- focus handling
- escape key close
- basic portal-style mounting if modal rendering inside normal tree becomes limiting

## Phase 8: StyleSheet and Theme Tokens

After core components are usable, add reusable Dart stylesheets.

Status: implemented.

### API

- `StyleSheet`
- `StyleRule`
- `ThemeTokens`
- `token(...)`
- `registerStyleSheet(...)`
- `createFlintApp(..., stylesheets: [])`

This can wait until components prove what the styling system needs. `DartStyle` comes first because it is simpler and immediately useful.

## Phase 9: EuPanel Adoption

Use Flint UI components inside EuPanel pages.

Status: first adoption pass implemented.

Start with:

- login page
- dashboard shell
- users table
- products/modules overview
- subscription detail panel

Move only repeated EuPanel patterns back into Flint UI.

Current adoption:

- EuPanel login page uses `Panel`, `Form`, `TextField`, `Button`, and `Head`.
- EuPanel dashboard page uses `AppShell`, `Sidebar`, `Topbar`, `Grid`, `Panel`, `StatCard`, `EmptyState`, and `DataTable`.
- The fullstack app analyzes cleanly and the Flint UI bundle compiles.

## Done Criteria

The component plan is finished when:

- `DartStyle` is available across visual components.
- Form, layout, data, navigation, and feedback components are implemented.
- Components have focused tests.
- Example Flint UI pages use the new components.
- EuPanel can build a dashboard without custom one-off HTML for common UI.
- Server-rendered SEO through `FlintPageMeta` and client `Head` both remain supported.

## Recommended Next Commit

Phases 1, 2, 3, 4, 4b, 5, 6, 7, 8, and the first Phase 9 adoption pass are implemented. The next commit should expand EuPanel adoption:

1. Replace EuPanel user and subscription pages with `DataTable`, `Pagination`, and form controls.
2. Add `StyleSheet` adoption for EuPanel page-level styles.
3. Move repeated EuPanel patterns back into Flint UI only after reuse appears in at least two products.
