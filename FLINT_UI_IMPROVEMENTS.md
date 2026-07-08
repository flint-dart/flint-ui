# Flint UI Improvement Notes

These notes come from using Flint UI to build real EuCloudHost customer and admin dashboards. The goal is not to turn Flint UI into a EuCloudHost-specific dashboard framework. Flint UI should stay a reusable UI foundation: primitives, styling, accessibility, rendering, form controls, and documented patterns. App-specific layouts such as customer sidebars, admin menus, hosting tables, billing flows, and product dashboards should stay in the application or in optional recipe/example packages.

## What Is Working Well

- Dart-only full stack development is fast because the developer does not switch between backend Dart and a separate frontend framework.
- `DartStyle` keeps layout and state styling close to the component tree.
- Server-rendered page props with client actions through `clientRouter` works well for interactive pages.
- Shared primitives such as `Button`, `TextField`, `Switch`, `Icon`, `Grid`, `Container`, and `ResponsiveGrid` are enough to build serious application pages.
- The component model is simple to read and refactor.

## Framework Boundary

Flint UI should provide reusable primitives and low-level composition tools. It should not own application navigation, business-specific dashboards, or product workflows.

Keep in Flint UI:

- Visual primitives such as `Button`, `Icon`, `TextField`, `Switch`, `Modal`, `Menu`, `Table`, `Pagination`, and layout components.
- Styling infrastructure such as `DartStyle`, design tokens, state styles, responsive styles, and theme support.
- Accessibility behavior and prop forwarding for interactive components.
- SSR-safe rendering behavior.
- Generic examples and recipes.

Keep in the app:

- Customer/admin sidebars and exact navigation trees.
- Hosting, billing, domains, compute, cloud, affiliate, and support workflows.
- Product-specific tables and filters.
- Business copy, status names, permissions, and route structure.
- EuCloudHost theme decisions that do not belong to every Flint UI framework.

## Missing Core Component Features

- Every visual primitive should consistently accept `dartStyle`, especially icons, media, form controls, and low-level layout elements.
- Form controls should expose first-class disabled, readonly, help text, error text, input props, and loading behavior consistently.
- `Switch` should have richer dashboard-ready variants so settings pages do not need custom switch rows.
- `TextField` should make locked identity fields look intentionally locked, not broken or inactive.
- Common accessibility props such as `aria-label`, `aria-describedby`, `role`, and `title` should be easy to pass through every interactive component.

## Reusable Component Gaps

Flint UI can provide generic building blocks that make data-heavy pages easier without becoming a dashboard product:

- Generic table primitive with aligned columns, empty states, loading states, row actions, optional bulk selection, and responsive behavior.
- Generic pagination primitive with page size control, total summary, and disabled states.
- Generic menu / popover primitive for action menus.
- Generic badge/status component with semantic variants such as success, warning, danger, pending, neutral, and info.
- Generic modal and drawer primitives.
- Generic toast/notice system.

Do not put EuCloudHost-specific table columns, hosting actions, subscription language, sidebar structure, or admin/customer navigation into Flint UI.

## Forms And Settings Primitives

- Provide a generic switch row primitive so settings pages do not need to make switches look like buttons.
- Inputs should support clear helper text and validation without every page rebuilding the same pattern.
- Password fields should have optional visibility toggles and strength hints.
- Confirmation actions should have a standard pattern for risky changes such as disabling 2FA or deleting resources.
- Multi-section forms should support saved state, dirty state, and section-level submit buttons.

## Auth And Security Primitives

Flint UI can provide generic security UI primitives, but the actual auth flow belongs to the app:

- QR code display
- secret fallback display
- verification code input
- enabled/disabled status display
- confirmation controls for risky actions

Do not put EuCloudHost auth routes, login rules, support instructions, or account policy into Flint UI.

Reusable examples can show a 2FA setup flow, but those examples should stay as recipes, not framework policy.

Other generic security primitives may include:

- Readonly identity field display for values users should not edit, such as login email.
- Security detail list for values such as last login, IP address, user agent, and trusted devices.

## Media, Browser, And Interactive Primitives

- Browser APIs should be exposed through safe controller-style abstractions where possible.
- Media capture, geolocation, canvas, and media preview should stay server-safe and have stub behavior for SSR.
- Canvas and media components need explicit examples and tests because they are more likely to fail silently.

## Styling And Theme Improvements

- Create a neutral application theme token set that apps can extend.
- Standardize spacing, border radius, typography scale, shadows, focus rings, and disabled states.
- Provide light/dark theme examples that work across all built-in components.
- Avoid one-off style maps in application code when the same pattern is repeated across pages.

## Routing And Page Patterns

- Keep route names, middleware, permissions, sidebar trees, and business workflows in the application.
- Flint UI should document reusable page patterns: server page props, app-owned shells, browser navigation, query state, and `clientRouter` action calls.
- List pages should use server-provided initial data, query-string pagination and filters, and a reusable pagination control.
- Manage/detail pages should keep the main object visible and let the app compose action menus, drawers, or modals from primitives.
- Settings pages should use form primitives such as `TextField(readonly: true)`, `SwitchRow`, `Select`, and explicit save buttons.
- Checkout pages should be shown as a pattern only; pricing, currency, invoice timing, payment gateways, and callbacks stay app-level.
- CRUD examples should show app-owned API paths with `clientRouter.group('/api/...')`, not framework-owned resource names.
- Provide examples of `AppShell` and `PageShell`, but do not make sidebar/navigation a required framework-level concept.

## Documentation Gaps

- Add a component gallery with real application examples.
- Add copy-paste examples for forms, tables, filters, action menus, modals, and pagination.
- Add guidance on when to create app-specific components versus moving reusable pieces into Flint UI.
- Document SSR-safe behavior for widgets that touch browser APIs.
- Document package compatibility rules, especially Dart SDK constraints and dependency choices.
inside flint/flint-docs

## Testing Improvements

- Add focused widget tests for every component prop surface.
- Add SSR rendering tests for browser-sensitive widgets.
- Add examples that can be rendered and visually inspected.
- Add regression tests for `dartStyle` merging, state styles, disabled states, and accessibility props.

## Package And SDK Policy

- Keep the SDK constraint broad unless Flint UI needs a new Dart language feature.
- Prefer dependencies that work with the same Dart SDK range as FlintDart and EuCloudHost deployments.
- Avoid raising the minimum Dart SDK only for small UI helpers when a compatible package version or local implementation is enough.
- When a dependency raises the SDK floor, document why and update FlintDart, Flint UI, and app deployments together.

## Recommended Next Steps

1. Build generic primitives: table, pagination, menu/popover, badge/status, modal, drawer, and toast.
2. Improve form controls: switch rows, locked fields, password field, validation summary, and confirmation controls.
3. Add a generic QR code component or utility that apps can use for 2FA and other workflows.
4. Document EuCloudHost patterns only as app-level case studies, not framework defaults.
5. Expand tests around SSR, `dartStyle`, accessibility, and dashboard components.
