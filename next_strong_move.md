# Flint UI: Next Strong Moves

Flint UI is moving toward a Dart-native web UI layer for fullstack FlintDart apps: components, layout, styling, root design, responsive behavior, and application structure without requiring CSS files.

This roadmap lists the strongest next additions and the plan to achieve them.

## 1. Interaction States

Add typed state styles directly to `DartStyle`.

Status: implemented.

Target API:

```dart
DartStyle(
  background: Colors.blue600,
  hover: DartStyle(background: Colors.blue700),
  focusVisible: DartStyle(shadow: FocusRing.blue),
  active: DartStyle(transform: StyleTransform.scale(0.98)),
)
```

Plan:

- Done: added `hover`, `focus`, `focusVisible`, `active`, `disabled`, `checked`, `selected`, `expanded`, and `invalid` state fields to `DartStyle`.
- Done: added scoped class generation whenever state styles or responsive styles are present.
- Done: state and responsive CSS use the same browser style injection path.
- Done: state CSS is emitted with `!important` so it can override base inline styles.
- Done: added tests proving states stay out of inline styles and compile into scoped CSS.
- Done: added `StyleTransition` and `TransitionTiming`.
- Done: refactored the portfolio navbar, buttons, skills, links, and project cards to use state styles.

## 2. Theme Tokens

Create a proper Dart theme system for colors, spacing, radius, shadows, typography, and layout scales.

Status: implemented.

Target API:

```dart
final appTheme = FlintTheme(
  colors: FlintColors(primary: Colors.blue600),
  spacing: FlintSpacing(scale: 4),
  radius: FlintRadius(md: 8),
);
```

Plan:

- Done: introduced `FlintTheme`.
- Done: added grouped token maps for colors, spacing, radii, shadows, fonts, and custom tokens.
- Done: added `ThemeToken.color`, `ThemeToken.space`, `ThemeToken.radius`, `ThemeToken.shadow`, and `ThemeToken.font`.
- Done: token references compile to CSS variables, so they work in inline `DartStyle`, responsive styles, and state styles.
- Done: `RootDesign` can receive a theme and emit CSS variables at `:root`.
- Done: added tests for theme variables and token references.
- Done: moved key portfolio values into `portfolioTheme`.

## 3. Component Variants

Make common components easier to style consistently.

Status: implemented.

Target API:

```dart
Button(
  variant: ButtonVariant.primary,
  size: ComponentSize.lg,
)
```

Plan:

- Done: audited existing widget variants and moved common variant logic into the shared theme layer.
- Done: added token-backed variants for `Button`, `IconButton`, `Link`, `StatusBadge`, `StatCard`, `TextField`, `TextArea`, `Select`, `Tabs`, and `Pagination`.
- Done: connected variants to theme tokens with fallback values.
- Done: preserved escape hatches through `dartStyle`, control-level Dart styles, and final style maps.
- Done: added tests for button, link, badge, card, input, tabs, and pagination variants.

## 4. Layout Primitives

Add stronger primitives for common app layouts.

Status: implemented.

Target components:

```dart
Center()
Box()
SafeArea()
ResponsiveGrid()
AspectRatioBox()
ConstrainedBox()
PageShell()
```

Plan:

- Done: added `Box`, `Center`, `SafeArea`, `ResponsiveGrid`, `AspectRatioBox`, `ConstrainedBox`, and `PageShell`.
- Done: implemented the primitives as small wrappers over Flint elements and existing Dart style infrastructure.
- Done: kept APIs typed while preserving `props`, `style`, and `dartStyle` escape hatches.
- Done: added responsive grid helpers that compile breakpoint styles into scoped CSS.
- Done: added tests for each new primitive and page shell composition.

## 5. Typed CSS Values

Continue replacing raw strings with typed values.

Status: implemented.

Target API:

```dart
objectFit: ObjectFit.cover,
textTransform: TextTransform.uppercase,
cursor: Cursor.pointer,
overflow: Overflow.hidden,
```

Plan:

- Done: added typed value helpers for `Cursor`, `Overflow`, `ObjectFit`, `TextTransform`, `FlexWrap`, and `Resize`.
- Done: widened `DartStyle` fields so typed values work for `cursor`, `overflow`, `flexWrap`, and `resize`.
- Done: kept `Object` support as the advanced fallback path.
- Done: converted internal button, nav, form textarea, wrap, and portfolio usage away from common raw strings.
- Done: added tests proving every new value family compiles correctly.

## 6. Animation And Transitions

Add typed transitions and simple animation helpers.

Status: implemented.

Target API:

```dart
DartStyle(
  transition: Transition.all(duration: 180),
  hover: DartStyle(transform: StyleTransform.translateY(-2)),
)
```

Plan:

- Done: `transition` already exists on `DartStyle`; added `animation` and `willChange`.
- Done: added typed `StyleAnimation`, `AnimationIteration`, `AnimationDirection`, `AnimationFillMode`, `AnimationPlayState`, and `WillChange`.
- Done: kept existing `StyleTransition` helpers for `all`, `colors`, `transform`, and custom properties.
- Done: added `StyleKeyframes` and `KeyframeStep` support through `RootDesign`.
- Done: registered default Flint keyframes for `flint-spin` and `flint-fade-in` when a Flint app starts.
- Done: moved `Spinner` to typed animation values and added tests for animation, will-change, and keyframe CSS.

## 7. Form Validation UI

Make forms work naturally with FlintDart backend validation.

Status: implemented.

Target API:

```dart
TextField(
  name: 'email',
  error: errors.field('email'),
)
```

Plan:

- Done: added `FormErrors` as the client-side validation error shape.
- Done: `FormErrors.from(...)` maps backend-style `{ errors: { field: [...] } }` payloads into field messages.
- Done: `FormController` now stores `FormErrors`, exposes `error(field)`, and captures thrown validation payloads during `submit`.
- Done: `TextField`, `TextArea`, `Select`, `Checkbox`, `Switch`, `FileInput`, and `RadioGroup` can resolve errors by `name` from `FormErrors`.
- Done: controls keep `aria-invalid` and `aria-describedby` wired to generated help/error text.
- Done: added tests for backend payload mapping, submit validation capture, and control-level error resolution.

## 8. Page Layout System

Create app-level shells for common fullstack app surfaces.

Status: implemented.

Target API:

```dart
PageShell(
  nav: AppNav(...),
  body: DashboardPage(...),
  footer: AppFooter(...),
)
```

Plan:

- Done: added `PortfolioShell`, `DashboardShell`, `AuthShell`, `DocsShell`, and `MarketingShell`.
- Done: built shells on top of `PageShell`, `AppShell`, `SafeArea`, `ConstrainedBox`, and `ResponsiveGrid`.
- Done: shells use DartStyle and theme token fallbacks for common backgrounds, text, surfaces, borders, shadows, and spacing.
- Done: each shell exposes slot-based APIs for nav, hero/header, sidebar, body, actions, user, and footer content.
- Done: added tests proving each shell composes the expected semantic page surface.

## 9. SEO And Head From Dart

Improve page metadata from the Dart UI side while preserving server-side metadata.

Status: implemented.

Target API:

```dart
Head(
  title: 'Portfolio',
  description: 'Fullstack Flutter and FlintDart developer.',
)
```

Plan:

- Done: expanded `Head` with SEO fields for `title`, `description`, `canonical`, Open Graph image/type/url/title/description, site name, and locale.
- Done: added `Head.seo(...)` as the route-level metadata API.
- Done: head sync now upserts existing server-rendered tags by stable keys instead of duplicating them.
- Done: server `res.page(... meta: ...)` can remain the first-render source of truth, while Dart updates the browser head after mount/navigation.
- Done: added browser tests for title/meta rendering, server tag reuse, and stable Flint head tag updates.

## 10. CLI Generator

Generate UI structure quickly from FlintDart.

Target commands:

```bash
flint --make-ui --p / -page Portfolio
flint --make-ui --c / -component ProjectCard
flint --make:ui root-design
```

Plan:

- Add generator templates for page, component, section, and root design files.
- Auto-register pages in the component registry when safe.
- Support a `--with-root-design` option.
- Document generated structure.

## Recommended Immediate Sprint

The next strongest sprint should be:

1. Add `hover`, `focusVisible`, `active`, and `transition` to `DartStyle`.
2. Add typed value helpers for `Cursor`, `Overflow`, `ObjectFit`, and `TextTransform`.
3. Refactor the portfolio navbar, buttons, and project cards to use those features.
4. Add tests for state styles, transitions, and typed values.

This will make Flint UI feel immediately more production-ready because modern interaction polish will live fully in Dart.
