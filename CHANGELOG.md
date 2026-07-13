# Changelog

## 0.1.14 - 2026-07-13

### Added
- Added `ClientRouter.query(...)` and generic `request('QUERY', ...)` dispatch for HTTP QUERY requests.
- Added public chart and slider widget exports.

### Changed
- Updated `flint_client` dependency to `^0.0.5`.

## 0.1.13 - 2026-07-08

### Added
- Added `TextField(readonly: true)` for locked identity values and `SwitchRow` for settings-style boolean preferences.
- Added `MediaDevicesController` for browser camera, microphone, camera-and-microphone, screen-share, media device listing, and stream stopping.
- Added `GeoLocationController` for browser current-position lookup, live location watching, and clearing active watches.
- Added `Video`, `Audio`, and `MediaPreview` components for native media playback and live browser media stream previews.
- Added `MediaElementController` for controlling Flint video, audio, and media preview playback from Dart.
- Added `MediaRecorderController`, `PhotoCaptureController`, and `CapturedMedia` helpers for recording streams, taking photos, and preparing base64 upload payloads.
- Added `Canvas`, `CanvasController`, retained canvas objects, and export-to-image helpers for Fabric-like drawing workflows.
- Added rounded rectangles, no-border canvas paint support, and image pattern fills for Flint canvas rectangles.
- Added canvas object update, ordering, hit testing, selection, dragging, movement, and JSON import/export helpers.
- Added canvas object resize and rotation helpers with rotated browser rendering and JSON persistence.
- Added canvas image objects and undo/redo history for retained canvas scenes.
- Added canvas selection handles plus keyboard delete, arrow-key movement, copy, and paste controls.
- Added canvas multi-selection grouping and controller callbacks for selection, changes, movement, resize, and rotation.
- Added canvas object styling helpers plus layer-panel metadata for names, renaming, lock, hide, and layer listing.
- Added canvas snapping, alignment, and text-editing helpers with browser double-click text editing support.
- Added canvas pointer/hover/operation lifecycle callbacks and selected-scene/backend JSON export/import helpers.
- Added canvas history batching, history callbacks, history clearing/limits, and browser marquee selection.
- Added canvas grid/ruler rendering, visual snap guides, and object movement/resize constraints.
- Added server-safe media and geolocation stubs so Flint UI pages can render for SSR/SEO without touching browser-only APIs.

### Fixed
- Preserved focused input and textarea values, focus, and cursor selection across component/root rerenders.
- Applied form `value` and `checked` props as live DOM properties in the browser renderer.

### Changed
- Removed the opinionated `Sidebar` widget from the public export surface; app navigation should be composed from primitives or app-owned components.

## 0.1.12 - 2026-07-06

### Added
- Added built-in light and dark theme provider support through `FlintThemeProvider`, `FlintThemes`, and `RootDesign.themeProvider`.
- Added global theme state with `flintTheme`, `FlintThemeController`, persisted theme mode storage, and `StateSignalListener`-friendly updates.
- Added `ThemeProvider` for subtree-level light or dark mode overrides.
- Added `DartStyle.light` and `DartStyle.dark` scoped style overrides for theme-aware components.
- Added `scrollbarDisplay` and `ScrollbarDisplay` helpers for scrollbar visibility control.

### Changed
- Updated `createFlintApp` and `renderPage` to accept theme/provider options and apply the active theme mode to the mounted app root.
- Improved modal surfaces to use theme tokens for panel, border, text, muted background, and dark-mode-friendly backdrop styling.

### Fixed
- Applied the active theme mode to the document root so app-wide `data-theme` CSS variables respond correctly when users toggle dark mode.
- Emitted vendor scrollbar rules for hidden scrollbars while keeping regular CSS output clean.

## 0.1.11 - 2026-06-18

### Added
- Added `RichTextEditor` component supporting inline text formatting, drag-and-drop / clipboard image uploading, and toolbar controls.
- Introduced `PageRegistry` mapping Flint page names to component builders.
- Added `onChanged` callback to `RichTextEditor` to support state synchronization in parent components.

### Changed
- Updated `createFlintApp` and `renderPage` signatures to accept `PageRegistry`.

### Deprecated
- Deprecated `FlintComponentRegistry` in favor of `PageRegistry` with migration warnings.

## 0.1.10 - 2026-06-16

### Added
- Added browser event helper exports for class-based Flint UI apps.

### Fixed
- Fixed page mounting so missing page handlers are explicit instead of silently rendering an internal fallback.

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
