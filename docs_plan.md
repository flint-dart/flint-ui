# Flint UI Documentation Plan

This plan tracks the work needed to turn Flint UI's current README, examples, and API comments into a complete documentation set for developers building FlintDart browser interfaces.

## Documentation Goals

- Help new users install Flint UI, mount an app, and render a FlintDart-backed page quickly.
- Explain the core mental model: components, nodes, rendering, pages, props, state, and lifecycle.
- Provide practical guides for styling, forms, browser APIs, page middleware, and FlintDart integration.
- Build a component catalog that shows common usage patterns for every public widget group.
- Keep generated API reference available through `dart doc`.
- Make examples runnable and easy to copy into real apps.

## Proposed Structure

```text
doc/
  index.md
  getting-started.md
  concepts.md
  pages.md
  styling.md
  components.md
  forms.md
  browser-apis.md
  examples.md
  api/
```

## Workstreams

### 1. README Refresh

Keep `README.md` as the public front door.

- Shorten long reference-style sections once deeper docs exist.
- Keep install, quick start, package status, and core examples.
- Link to the documentation index, examples, and generated API reference.
- Keep pub.dev-friendly snippets near the top.

### 2. Getting Started

Create `doc/getting-started.md`.

- Install `flint_ui`.
- Import `package:flint_ui/flint_ui.dart`.
- Create a browser entrypoint.
- Mount with `createFlintApp`.
- Render a page from FlintDart with `res.page`.
- Compile Dart to JavaScript.
- Explain local monorepo path overrides.

### 3. Core Concepts

Create `doc/concepts.md`.

- Explain `FlintComponent`.
- Explain `FlintNode`, `FlintElement`, text nodes, fragments, and raw `h()` nodes.
- Document `setState`.
- Document lifecycle hooks: `didMount`, `didUpdate`, and `willUnmount`.
- Explain when to use `flint_ui.dart` vs `flint_ui_core.dart`.

### 4. Pages And FlintDart Integration

Create `doc/pages.md`.

- Document `FlintComponentRegistry`.
- Explain server-provided page props.
- Document `FlintPageContext`.
- Show client-side page middleware.
- Show auth redirect patterns.
- Explain that server routes still need real authorization checks.
- Include a complete FlintDart route plus browser entrypoint example.

### 5. Styling Guide

Create `doc/styling.md`.

- Cover style maps and `DartStyle`.
- Document `SizeValue`, `EdgeInsets`, `Border`, `Shadow`, colors, gradients, and flex helpers.
- Show responsive styles with `sm`, `md`, `lg`, and `xl`.
- Explain `StyleSheet`, `StyleRule`, hover/focus states, and generated class names.
- Cover themes, root design tokens, keyframes, transitions, and animations.
- Include common layout recipes.

### 6. Component Catalog

Create `doc/components.md`.

Document each public widget group:

- Primitives: `Container`, `Row`, `Column`, `Text`, `Link`, `Image`, `Figure`.
- Actions: `Button`, `ButtonGroup`, `IconButton`.
- Forms: `Form`, `TextField`, `TextArea`, `Select`, `Checkbox`, `RadioGroup`, `Switch`, `FileInput`, `FieldGroup`.
- Layout: `AppShell`, `PageShell`, `Grid`, `ResponsiveGrid`, `Section`, `Panel`, `PageHeader`, `Sidebar`, `Topbar`, `Stack`, `Wrap`, `Spacer`, `Divider`, `EmptyState`.
- Data: `Avatar`, `Table`, `DataTable`, `DescriptionList`, `ProgressBar`, `Timeline`, `UsageMeter`, `StatCard`.
- Feedback: `Alert`, `Spinner`, `StatusBadge`.
- Navigation: `Breadcrumbs`, `Pagination`, `SearchBox`, `Tabs`.
- Overlays: `ConfirmAction`, `Drawer`, `Modal`, `Popover`, `Skeleton`, `Toast`, `Tooltip`.

Each component entry should include:

- Purpose.
- Minimal example.
- Key constructor arguments.
- Common usage notes.
- Accessibility notes where useful.

### 7. Forms Guide

Create `doc/forms.md`.

- Explain form composition.
- Document text fields, text areas, selects, choice controls, switches, and file inputs.
- Explain `TextEditingController`.
- Explain `FormController`.
- Show validation and error rendering.
- Include a login form and settings form example.

### 8. Browser APIs

Create `doc/browser-apis.md`.

- Document `navigation`.
- Document `query`.
- Document `localStorage` and `sessionStorage`.
- Document `cookies`.
- Document `AuthSessionManager` and `authSession`.
- Document `clientRouter`.
- Document `EnvironmentConfig` and `env`.

### 9. Examples

Expand `example/` with focused examples.

Suggested files:

```text
example/
  main.dart
  dashboard.dart
  auth_flow.dart
  forms.dart
  data_table.dart
  styling.dart
```

Each example should be small, runnable, and referenced from the docs.

### 10. API Reference

Keep generated docs under `doc/api`.

Regenerate after public API documentation changes:

```bash
dart doc
```

Generated entrypoint:

```text
doc/api/index.html
```

## Quality Checklist

- Every public export has a useful Dartdoc comment.
- README links match actual docs files.
- Code snippets compile or are clearly marked as illustrative.
- Examples use the current public API.
- Docs mention the package is pre-1.0 and APIs may change.
- `dart analyze` passes.
- `dart test -p chrome` passes.
- `dart doc` completes successfully.

## Suggested Order

1. Add `doc/index.md`.
2. Create `getting-started.md` and move expanded setup content there.
3. Create `concepts.md` and `pages.md`.
4. Create `styling.md`.
5. Create `components.md`.
6. Create `forms.md` and `browser-apis.md`.
7. Expand `example/`.
8. Refresh README links.
9. Regenerate API docs with `dart doc`.
10. Update `CHANGELOG.md`.
