part of '../style.dart';

/// Responsive breakpoint used by scoped Dart styles.
enum Breakpoint {
  /// Small screens, starting at 640px.
  sm(640),

  /// Medium screens, starting at 768px.
  md(768),

  /// Large screens, starting at 1024px.
  lg(1024),

  /// Extra-large screens, starting at 1280px.
  xl(1280);

  /// Minimum viewport width for this breakpoint.
  final int minWidth;

  /// Creates a breakpoint with a minimum width.
  const Breakpoint(this.minWidth);
}

/// Collection of design token values that compile to CSS variables.
class ThemeTokens {
  /// Token values keyed by logical token name.
  final Map<String, Object?> values;

  /// Creates a token collection from [values].
  const ThemeTokens(this.values);

  /// Resolves a token by [name].
  Object? resolve(String name) => values[name];

  /// CSS custom properties generated from token values.
  Map<String, Object?> get cssVariables => {
    for (final entry in values.entries)
      '--${_tokenCssName(entry.key)}': entry.value,
  };
}

/// Reference to a design token CSS variable.
class TokenRef {
  /// Logical token name.
  final String name;

  /// Optional fallback value used when the CSS variable is missing.
  final Object? fallback;

  /// Creates a token reference.
  const TokenRef(this.name, {this.fallback});

  /// Converts this reference to a CSS `var(...)` expression.
  String toCss() {
    final variable = 'var(--${_tokenCssName(name)}';
    if (fallback == null) return '$variable)';
    return '$variable, ${cssValue(fallback)})';
  }

  /// Returns the CSS variable reference.
  @override
  String toString() => toCss();
}

/// Creates a reference to a design token.
TokenRef token(String name, {Object? fallback}) {
  return TokenRef(name, fallback: fallback);
}

/// Convenience factories for common theme token namespaces.
class ThemeToken {
  /// Prevents creating a token factory container.
  const ThemeToken._();

  /// References a color token.
  static TokenRef color(String name, {Object? fallback}) =>
      token('color.$name', fallback: fallback);

  /// References a spacing token.
  static TokenRef space(String name, {Object? fallback}) =>
      token('space.$name', fallback: fallback);

  /// References a radius token.
  static TokenRef radius(String name, {Object? fallback}) =>
      token('radius.$name', fallback: fallback);

  /// References a shadow token.
  static TokenRef shadow(String name, {Object? fallback}) =>
      token('shadow.$name', fallback: fallback);

  /// References a font token.
  static TokenRef font(String name, {Object? fallback}) =>
      token('font.$name', fallback: fallback);
}

/// Design theme that groups colors, spacing, radii, shadows, and fonts.
class FlintTheme {
  /// Theme name used for identification.
  final String name;

  /// Color token values keyed by color name.
  final Map<String, Object?> colors;

  /// Spacing token values keyed by spacing name.
  final Map<String, Object?> spacing;

  /// Radius token values keyed by radius name.
  final Map<String, Object?> radii;

  /// Shadow token values keyed by shadow name.
  final Map<String, Object?> shadows;

  /// Font token values keyed by font name.
  final Map<String, Object?> fonts;

  /// Additional token values merged with the named token groups.
  final ThemeTokens tokens;

  /// Creates a Flint UI design theme.
  const FlintTheme({
    this.name = 'flint',
    this.colors = const {},
    this.spacing = const {},
    this.radii = const {},
    this.shadows = const {},
    this.fonts = const {},
    this.tokens = const ThemeTokens({}),
  });

  /// All theme token groups flattened into one token collection.
  ThemeTokens get allTokens {
    return ThemeTokens({
      for (final entry in colors.entries) 'color.${entry.key}': entry.value,
      for (final entry in spacing.entries) 'space.${entry.key}': entry.value,
      for (final entry in radii.entries) 'radius.${entry.key}': entry.value,
      for (final entry in shadows.entries) 'shadow.${entry.key}': entry.value,
      for (final entry in fonts.entries) 'font.${entry.key}': entry.value,
      ...tokens.values,
    });
  }

  /// CSS custom properties generated from all theme tokens.
  Map<String, Object?> get cssVariables => allTokens.cssVariables;
}

/// CSS rule with base styles and common interaction state styles.
class StyleRule {
  /// Base CSS declarations.
  final Map<String, Object?> styles;

  /// CSS declarations for `:hover`.
  final Map<String, Object?> hover;

  /// CSS declarations for `:focus`.
  final Map<String, Object?> focus;

  /// CSS declarations for `:focus-visible`.
  final Map<String, Object?> focusVisible;

  /// CSS declarations for `:active`.
  final Map<String, Object?> active;

  /// CSS declarations for `:disabled`.
  final Map<String, Object?> disabled;

  /// CSS declarations for `:checked`.
  final Map<String, Object?> checked;

  /// CSS declarations for `[aria-selected="true"]`.
  final Map<String, Object?> selected;

  /// CSS declarations for `[aria-expanded="true"]`.
  final Map<String, Object?> expanded;

  /// CSS declarations for `[aria-invalid="true"]`.
  final Map<String, Object?> invalid;

  /// Nested rules used inside at-rules such as media queries.
  final Map<String, Map<String, Object?>> nestedRules;

  /// Creates a style rule with optional interaction state declarations.
  const StyleRule(
    this.styles, {
    this.hover = const {},
    this.focus = const {},
    this.focusVisible = const {},
    this.active = const {},
    this.disabled = const {},
    this.checked = const {},
    this.selected = const {},
    this.expanded = const {},
    this.invalid = const {},
  }) : nestedRules = const {};

  /// Creates a nested style rule for an at-rule.
  const StyleRule.nested(this.nestedRules)
    : styles = const {},
      hover = const {},
      focus = const {},
      focusVisible = const {},
      active = const {},
      disabled = const {},
      checked = const {},
      selected = const {},
      expanded = const {},
      invalid = const {};
}

/// Named stylesheet that compiles class-based style rules to CSS text.
class StyleSheet {
  /// Stylesheet namespace used in generated class names.
  final String name;

  /// Style rules keyed by selector or class key.
  final Map<String, StyleRule> rules;

  /// Optional tokens used to resolve [TokenRef] values.
  final ThemeTokens? tokens;

  /// Creates a named stylesheet from [rules].
  const StyleSheet(this.name, this.rules, {this.tokens});

  /// Returns the generated class name for [key].
  String className(String key) {
    final normalized = key.startsWith('.') ? key.substring(1) : key;
    return '${_safeCssIdent(name)}-${_safeCssIdent(normalized)}';
  }

  /// Compiled CSS text for this stylesheet.
  String get cssText {
    final chunks = <String>[];

    for (final entry in rules.entries) {
      final selector = entry.key;
      final rule = entry.value;

      if (selector.startsWith('@')) {
        final nested = rule.nestedRules.entries
            .map((nestedEntry) {
              return _compileRule(
                _selector(nestedEntry.key),
                nestedEntry.value,
              );
            })
            .join('\n');
        chunks.add('$selector {\n$nested\n}');
        continue;
      }

      final classSelector = _selector(selector);
      chunks.add(_compileRule(classSelector, rule.styles));
      _appendState(chunks, classSelector, ':hover', rule.hover);
      _appendState(chunks, classSelector, ':focus', rule.focus);
      _appendState(chunks, classSelector, ':focus-visible', rule.focusVisible);
      _appendState(chunks, classSelector, ':active', rule.active);
      _appendState(chunks, classSelector, ':disabled', rule.disabled);
      _appendState(chunks, classSelector, ':checked', rule.checked);
      _appendState(
        chunks,
        classSelector,
        '[aria-selected="true"]',
        rule.selected,
      );
      _appendState(
        chunks,
        classSelector,
        '[aria-expanded="true"]',
        rule.expanded,
      );
      _appendState(
        chunks,
        classSelector,
        '[aria-invalid="true"]',
        rule.invalid,
      );
    }

    return chunks.where((chunk) => chunk.trim().isNotEmpty).join('\n');
  }

  String _selector(String selector) {
    if (selector.startsWith('.')) return '.${className(selector)}';
    return selector;
  }

  String _compileRule(String selector, Map<String, Object?> styles) {
    final body = _styleBody(styles);
    if (body.isEmpty) return '';
    return '$selector {\n$body\n}';
  }

  void _appendState(
    List<String> chunks,
    String selector,
    String state,
    Map<String, Object?> styles,
  ) {
    final rule = _compileRule('$selector$state', styles);
    if (rule.isNotEmpty) chunks.add(rule);
  }

  String _styleBody(Map<String, Object?> styles) {
    final entries = styles.entries
        .where((entry) => entry.value != null)
        .map((entry) => '  ${entry.key}: ${_resolveValue(entry.value)};')
        .toList(growable: false);
    return entries.join('\n');
  }

  String _resolveValue(Object? value) {
    if (value is TokenRef) {
      return cssValue(tokens?.resolve(value.name) ?? '');
    }
    if (value is Iterable) {
      return value.map(_resolveValue).join(' ');
    }
    return cssValue(value);
  }
}

/// One step in a CSS `@keyframes` animation.
class KeyframeStep {
  /// Step offset such as `from`, `to`, or a percentage.
  final Object offset;

  /// Style declarations for this keyframe step.
  final DartStyle style;

  /// Creates a keyframe step at [offset].
  const KeyframeStep(this.offset, this.style);

  /// Creates a `from` keyframe step.
  const KeyframeStep.from(this.style) : offset = 'from';

  /// Creates a `to` keyframe step.
  const KeyframeStep.to(this.style) : offset = 'to';

  /// Creates a percentage keyframe step.
  const KeyframeStep.percent(num percent, this.style) : offset = percent;

  /// CSS selector for this keyframe step.
  String get selector {
    if (offset is num) return '${offset}%';
    return offset.toString();
  }
}

/// CSS `@keyframes` animation built from typed style steps.
class StyleKeyframes {
  /// Animation name.
  final String name;

  /// Ordered keyframe steps.
  final List<KeyframeStep> steps;

  /// Creates keyframes from a [name] and [steps].
  const StyleKeyframes(this.name, this.steps);

  /// Creates keyframes with `from` and `to` steps.
  factory StyleKeyframes.fromTo({
    required String name,
    required DartStyle from,
    required DartStyle to,
  }) {
    return StyleKeyframes(name, [KeyframeStep.from(from), KeyframeStep.to(to)]);
  }

  /// Creates a reusable rotate animation.
  static StyleKeyframes spin({String name = 'flint-spin'}) {
    return StyleKeyframes.fromTo(
      name: name,
      from: DartStyle(transform: StyleTransform.rotate(0)),
      to: DartStyle(transform: StyleTransform.rotate('360deg')),
    );
  }

  /// Creates a reusable fade-in animation.
  static StyleKeyframes fadeIn({String name = 'flint-fade-in'}) {
    return StyleKeyframes.fromTo(
      name: name,
      from: const DartStyle(opacity: 0),
      to: const DartStyle(opacity: 1),
    );
  }

  /// Compiled CSS `@keyframes` text.
  String get cssText {
    final body = steps
        .map((step) {
          final stepBody = rootStyleToCss(step.style.toMap());
          if (stepBody.isEmpty) return '';
          return '  ${step.selector} { $stepBody; }';
        })
        .where((chunk) => chunk.isNotEmpty)
        .join('\n');
    if (body.isEmpty) return '';
    return '@keyframes $name {\n$body\n}';
  }
}

/// Global design CSS for root, document, and app-wide selectors.
class RootDesign {
  /// Unique name used when registering this root design.
  final String name;

  /// Optional theme whose tokens are emitted as CSS variables.
  final FlintTheme? theme;

  /// Styles emitted for the `:root` selector.
  final DartStyle? root;

  /// Styles emitted for the `html` selector.
  final DartStyle? html;

  /// Styles emitted for the `body` selector.
  final DartStyle? body;

  /// Styles emitted for the universal `*` selector.
  final DartStyle? all;

  /// Styles emitted for the `a` selector.
  final DartStyle? links;

  /// Additional global selectors and their styles.
  final Map<String, DartStyle> selectors;

  /// Global keyframes emitted with the root design.
  final List<StyleKeyframes> keyframes;

  /// Creates a global root design.
  const RootDesign({
    this.name = 'root',
    this.theme,
    this.root,
    this.html,
    this.body,
    this.all,
    this.links,
    this.selectors = const {},
    this.keyframes = const [],
  });

  /// Compiled global CSS text.
  String get cssText {
    final chunks = <String>[
      if (theme != null) _compileRootMap(':root', theme!.cssVariables),
      if (root != null) _compileRootRule(':root', root!),
      if (all != null) _compileRootRule('*', all!),
      if (html != null) _compileRootRule('html', html!),
      if (body != null) _compileRootRule('body', body!),
      if (links != null) _compileRootRule('a', links!),
      for (final entry in selectors.entries)
        _compileRootRule(entry.key, entry.value),
      for (final keyframe in keyframes) keyframe.cssText,
    ];

    return chunks.where((chunk) => chunk.trim().isNotEmpty).join('\n');
  }

  String _compileRootRule(String selector, DartStyle style) {
    final body = _rootStyleToCss(style.toMap());
    if (body.trim().isEmpty) return '';
    return '$selector { $body; }';
  }

  String _compileRootMap(String selector, Map<String, Object?> style) {
    final body = _rootStyleToCss(style);
    if (body.trim().isEmpty) return '';
    return '$selector { $body; }';
  }

  String _rootStyleToCss(Map<String, Object?> style) {
    return rootStyleToCss(style);
  }
}

/// Converts a style map into root-level CSS declarations.
String rootStyleToCss(Map<String, Object?> style) {
  return style.entries
      .where((entry) => entry.value != null && entry.key != '_cssText')
      .map((entry) => '${entry.key}: ${_rootCssValue(entry.key, entry.value)}')
      .join('; ');
}

String _rootCssValue(String property, Object? value) {
  const unitlessProperties = {
    'flex',
    'flex-grow',
    'flex-shrink',
    'font-weight',
    'line-height',
    'opacity',
    'z-index',
  };

  return cssValue(value, unitlessNumber: unitlessProperties.contains(property));
}

String _tokenCssName(String name) => _safeCssIdent(name.replaceAll('.', '-'));
