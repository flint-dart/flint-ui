# Flint UI Dartdoc Plan

This plan focuses only on `///` API comments for Flint UI. The goal is to make the generated `dart doc` reference useful and eventually allow `public_member_api_docs` to be enabled without analyzer issues.

## Goal

- Document every public symbol exported by `package:flint_ui/flint_ui.dart`.
- Document every public symbol exported by `package:flint_ui/flint_ui_core.dart`.
- Keep API comments short, practical, and reference-focused.
- Use longer explanations in the separate user guide documentation, not in Dartdoc.
- Regenerate API reference with `dart doc` after each major documentation pass.

## Comment Standard

Each public API comment should:

- Start with one direct sentence explaining what the symbol does.
- Add a second sentence only when behavior, lifecycle, browser state, or usage is not obvious.
- Mention browser-only behavior when an API reads or writes browser state.
- Mention FlintDart integration where an API depends on server-rendered page data.
- Explain constants and singleton helpers by saying when to use the shared instance.
- Explain constructors by describing the component purpose, not by repeating every parameter.
- Avoid copying long README/tutorial text.

Good examples:

```dart
/// Shared auth session helper backed by browser local storage.
///
/// Use this for simple browser-side login state in Flint UI apps.
const authSession = AuthSessionManager();
```

```dart
/// A page registry that maps server-rendered page names to UI components.
class FlintComponentRegistry { ... }
```

```dart
/// Renders a semantic button with Flint UI styling and browser click handling.
class Button extends FlintElement { ... }
```

## Work Order

### 1. Public Libraries

Files:

```text
lib/flint_ui.dart
lib/flint_ui_core.dart
```

Tasks:

- Confirm each library comment explains the intended import.
- Make export surface easy to understand from generated docs.

### 2. Core Runtime

Files:

```text
lib/src/component.dart
lib/src/node.dart
lib/src/html.dart
lib/src/component_props.dart
lib/src/browser_renderer.dart
lib/src/pages.dart
lib/src/head.dart
```

Document:

- `FlintComponent`
- `FunctionalComponent`
- `FlintNode`
- `FlintText`
- `FlintFragment`
- `FlintElement`
- `FlintComponentNode`
- raw HTML helpers
- component props helpers
- `FlintRoot`
- `createFlintApp`
- page registry/context/middleware
- head/meta helpers

### 3. Browser APIs

Files:

```text
lib/src/navigation/navigation.dart
lib/src/navigation/query_params.dart
lib/src/storage/browser_storage.dart
lib/src/storage/local_storage.dart
lib/src/storage/session_storage.dart
lib/src/storage/cookies.dart
lib/src/auth/auth_session.dart
lib/src/client/client_router.dart
lib/src/config/environment_config.dart
```

Document:

- `navigation`
- `currentUrl`, `currentPath`, `currentQuery`, `currentHash`, `currentUri`
- `query`
- `localStorage`
- `sessionStorage`
- `cookies`
- `authSession`
- `ClientRouter`
- `clientRouter`
- `EnvironmentConfig`
- `env`

Status: completed.

Notes:

- Placeholder comments were replaced with browser-specific Dartdoc.
- Singleton helpers now explain when to use the shared instance.
- `CookieSameSite` enum values are documented.
- `dart analyze` passes after this pass.

### 4. Styling APIs

Files:

```text
lib/src/style.dart
lib/src/style/dart_style.dart
lib/src/style/values.dart
lib/src/style/color.dart
lib/src/style/gradient.dart
lib/src/style/stylesheet.dart
lib/src/style_browser.dart
```

Document:

- `DartStyle`
- `SizeValue`
- `EdgeInsets`
- `Border`
- `Shadow`
- typed CSS value helpers
- `Color`
- `Colors`
- `Gradient`
- `Background`
- `Gradients`
- `StyleSheet`
- `StyleRule`
- `FlintTheme`
- `RootDesign`
- stylesheet registration functions

Status: completed.

Notes:

- `DartStyle` fields and scoped-style helpers are documented.
- Color, gradient, flex, background, and token helpers have CSS-specific comments.
- Stylesheet, theme, keyframe, and root design APIs have reference comments.
- Browser stylesheet registration helpers are documented.
- Placeholder generated comments were removed from styling files.
- `dart analyze` passes after this pass.

### 5. Shared Widget Theme API

File:

```text
lib/src/widgets/shared/theme.dart
```

Document:

- public enums
- shared theme style helpers
- public functions that resolve tone, size, variant, and state styles

Status: completed.

Notes:

- Tone, size, and variant enums are documented.
- Shared button, badge, card, input, navigation, icon, and spinner style helpers are documented.
- Tone color resolver helpers are documented.
- Placeholder generated comments were removed from the shared theme file.
- `dart analyze` passes after this pass.

### 6. Primitive And Action Widgets

Files:

```text
lib/src/widgets/primitives/
lib/src/widgets/actions/
```

Document:

- `Container`
- `Row`
- `Column`
- `Text`
- `Link`
- `Image`
- `Figure`
- `Button`
- `ButtonGroup`
- `IconButton`

Status: completed.

Notes:

- Primitive container, row, column, text, link, image, and figure widgets are documented.
- Image loading and decoding enum values are documented.
- Button, button group, and icon button APIs are documented.
- Placeholder generated comments were removed from primitive and action widget files.
- `dart analyze` passes after this pass.

### 7. Layout Widgets

Files:

```text
lib/src/widgets/layout/
```

Document:

- `AppShell`
- `PageShell`
- `PortfolioShell`
- `DashboardShell`
- `AuthShell`
- `DocsShell`
- `MarketingShell`
- `Grid`
- `ResponsiveGrid`
- `Section`
- `Panel`
- `PageHeader`
- `Sidebar`
- `Topbar`
- `Stack`
- `Wrap`
- `Spacer`
- `Divider`
- `EmptyState`
- layout utility widgets

Status: completed.

Notes:

- App shells, page shells, layout primitives, utility boxes, sidebar, and dashboard/stat surfaces are documented.
- Placeholder generated comments were removed from layout widget files.
- `dart analyze` passes after this pass.

### 8. Forms

Files:

```text
lib/src/widgets/forms/
```

Document:

- `Form`
- `TextField`
- `TextArea`
- `Select`
- `SelectOption`
- `Checkbox`
- `RadioGroup`
- `RadioOption`
- `Switch`
- `FileInput`
- `FieldGroup`
- `TextEditingController`
- `FormController`
- `FormErrors`
- form helper functions that are public

Status: completed.

Notes:

- Form controls, option models, field groups, controllers, and validation errors are documented.
- Public form helper functions and shared field styles have reference comments.
- Placeholder generated comments were removed from form widget files.
- `dart analyze` passes after this pass.

### 9. Data, Feedback, Navigation, And Overlays

Files:

```text
lib/src/widgets/data/
lib/src/widgets/feedback/
lib/src/widgets/navigation/
lib/src/widgets/overlays/
```

Document:

- data widgets: `Avatar`, `Table`, `DataTable`, `DescriptionList`, `ProgressBar`, `Timeline`, `UsageMeter`
- feedback widgets: `Alert`, `Spinner`, `StatusBadge`
- navigation widgets: `Breadcrumbs`, `Pagination`, `SearchBox`, `Tabs`
- overlay widgets: `ConfirmAction`, `Drawer`, `Modal`, `Popover`, `Skeleton`, `Toast`, `Tooltip`

Status: completed.

Notes:

- Data display widgets, table models, timeline items, and usage/progress surfaces are documented.
- Feedback, navigation, and overlay widgets now have focused reference comments.
- Placeholder generated comments were removed from section 9 widget files.
- `dart analyze` passes after this pass.

## Validation

Run after each pass:

```bash
dart format lib test example
dart analyze
dart test -p chrome
dart doc
```

Temporary release mode:

```yaml
linter:
  rules:
    public_member_api_docs: false
```

Final documentation mode:

```yaml
linter:
  rules:
    public_member_api_docs: true
```

The final target is:

- `dart analyze` reports no public documentation issues.
- `dart doc` completes successfully.
- Generated docs have no empty public API pages for exported symbols.
