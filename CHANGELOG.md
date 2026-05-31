# Changelog

## Unreleased

## 0.1.8 - 2026-05-31

### Added
- Added `FlintComponentRegistry.only(...)` for generated page-level entrypoints that should keep only the requested page component.

## 0.1.7 - 2026-05-31

### Changed
- Updated the package homepage and example docs link to the canonical Flint docs URL at `https://flintdart.dev`.

## 0.1.6 - 2026-05-31

### Added
- Added explicit `StatefulComponent` and `StatelessComponent` base classes so app code can communicate component lifecycle intent clearly.

### Changed
- `Component` remains a backwards-compatible alias for `StatefulComponent`.
- Child components are replaced by default during parent rebuilds so constructor-provided values stay fresh.
- Components that must survive parent rebuilds can opt in by overriding `preserveState` and copying constructor values with `updateFrom`.
- Functional components now extend `StatelessComponent`.

### Fixed
- Fixed stale child component values after a parent component rebuild.
- Improved rerender behavior for content, page middleware, resource views, state signal listeners, and head metadata components.

## 0.1.5 - 2026-05-26

### Added
- Added reactive resource state helpers for API-backed dashboards.
- Added browser document utilities, overlays, icons, and content widgets.
- Added a resource dashboard example using `FlintModelRecord` and `FlintModelApi`.

### Improved
- Expanded styling helpers for gradients, CSS values, and responsive layout behavior.
- Improved component rerendering support for browser-hosted Flint UI apps.
- Expanded README guidance for full-stack FlintDart usage.

### Tests
- Added coverage for resource controllers, state signals, browser document helpers, styles, and widgets.

## 0.1.4 - 2026-05-14

### Fixed
- Scoped `setState` rerenders to the component instance that owns the state.
- Preserved nested component state while rerendering component-local DOM boundaries.

## 0.1.3 - 2026-05-14

### Improved
- Adjusted analyzer lint configuration so package scoring is not blocked by documentation-roadmap infos.

## 0.1.2 - 2026-05-14

### Added
- Added class-level documentation comments across the public Flint UI API surface.

### Improved
- Expanded README installation and API documentation guidance.
- Documented the `dart doc` workflow and generated API output path.

## 0.1.1 - 2026-05-14

### Added
- Added a package example entrypoint for pub.dev.
- Added documentation comments across the public style API.

### Improved
- Improved pub.dev documentation scoring for the first Flint UI release.

## 0.1.0 - 2026-05-14

### Added
- Added the first pub.dev-ready Flint UI package release.
- Added Dart-first browser rendering primitives for Flint fullstack apps.
- Added component, node, page mounting, navigation, head, and browser storage APIs.
- Added typed Dart style helpers, gradients, stylesheets, color values, and size values.
- Added layout primitives including app shells, grids, panels, page layouts, page headers, sidebars, topbars, stacks, sections, and responsive grids.
- Added action, data display, feedback, form, navigation, overlay, and primitive widgets.
- Added form validation helpers and controller APIs.
- Added browser auth session helpers backed by `flint_client`.

### Improved
- Prepared the package to depend on hosted `flint_client: ^0.0.3`.
- Documented installation, quick start, components, styling, browser APIs, and FlintDart integration.

### Tests
- Added coverage for auth sessions, browser storage, client routing, cookies, data widgets, forms, head metadata, layout widgets, navigation, overlays, page middleware, styles, stylesheets, and core widgets.
