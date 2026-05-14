part of '../style.dart';

/// Options for the Breakpoint API.
enum Breakpoint {
  /// Creates a sm instance.
  sm(640),

  /// Creates a md instance.
  md(768),

  /// Creates a lg instance.
  lg(1024),

  /// Creates a xl instance.
  xl(1280);

  /// The minWidth value.
  final int minWidth;

  /// Creates a Breakpoint instance.
  const Breakpoint(this.minWidth);
}

/// Represents the ThemeTokens API in Flint UI.
class ThemeTokens {
  /// The values value.
  final Map<String, Object?> values;

  /// Creates a ThemeTokens instance.
  const ThemeTokens(this.values);

  Object? resolve(String name) => values[name];

  /// Returns the cssVariables value.
  Map<String, Object?> get cssVariables => {
    for (final entry in values.entries)
      '--${_tokenCssName(entry.key)}': entry.value,
  };
}

/// Represents the TokenRef API in Flint UI.
class TokenRef {
  /// The name value.
  final String name;

  /// The fallback value.
  final Object? fallback;

  /// Creates a TokenRef instance.
  const TokenRef(this.name, {this.fallback});

  /// Runs the toCss operation.
  String toCss() {
    final variable = 'var(--${_tokenCssName(name)}';
    if (fallback == null) return '$variable)';
    return '$variable, ${cssValue(fallback)})';
  }

  @override
  /// Runs the toString operation.
  String toString() => toCss();
}

TokenRef token(String name, {Object? fallback}) {
  return TokenRef(name, fallback: fallback);
}

/// Represents the ThemeToken API in Flint UI.
class ThemeToken {
  /// Creates a ThemeToken instance.
  const ThemeToken._();

  static TokenRef color(String name, {Object? fallback}) =>
      token('color.$name', fallback: fallback);

  static TokenRef space(String name, {Object? fallback}) =>
      token('space.$name', fallback: fallback);

  static TokenRef radius(String name, {Object? fallback}) =>
      token('radius.$name', fallback: fallback);

  static TokenRef shadow(String name, {Object? fallback}) =>
      token('shadow.$name', fallback: fallback);

  static TokenRef font(String name, {Object? fallback}) =>
      token('font.$name', fallback: fallback);
}

/// Represents the FlintTheme API in Flint UI.
class FlintTheme {
  /// The name value.
  final String name;

  /// The colors value.
  final Map<String, Object?> colors;

  /// The spacing value.
  final Map<String, Object?> spacing;

  /// The radii value.
  final Map<String, Object?> radii;

  /// The shadows value.
  final Map<String, Object?> shadows;

  /// The fonts value.
  final Map<String, Object?> fonts;

  /// The tokens value.
  final ThemeTokens tokens;

  /// Creates a FlintTheme instance.
  const FlintTheme({
    this.name = 'flint',
    this.colors = const {},
    this.spacing = const {},
    this.radii = const {},
    this.shadows = const {},
    this.fonts = const {},
    this.tokens = const ThemeTokens({}),
  });

  /// Returns the allTokens value.
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

  /// Returns the cssVariables value.
  Map<String, Object?> get cssVariables => allTokens.cssVariables;
}

/// Represents the StyleRule API in Flint UI.
class StyleRule {
  /// The styles value.
  final Map<String, Object?> styles;

  /// The hover value.
  final Map<String, Object?> hover;

  /// The focus value.
  final Map<String, Object?> focus;

  /// The focusVisible value.
  final Map<String, Object?> focusVisible;

  /// The active value.
  final Map<String, Object?> active;

  /// The disabled value.
  final Map<String, Object?> disabled;

  /// The checked value.
  final Map<String, Object?> checked;

  /// The selected value.
  final Map<String, Object?> selected;

  /// The expanded value.
  final Map<String, Object?> expanded;

  /// The invalid value.
  final Map<String, Object?> invalid;

  /// The nestedRules value.
  final Map<String, Map<String, Object?>> nestedRules;

  /// Creates a StyleRule instance.
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

  /// Creates a StyleRule instance.
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

/// Represents the StyleSheet API in Flint UI.
class StyleSheet {
  /// The name value.
  final String name;

  /// The rules value.
  final Map<String, StyleRule> rules;

  /// The tokens value.
  final ThemeTokens? tokens;

  /// Creates a StyleSheet instance.
  const StyleSheet(this.name, this.rules, {this.tokens});

  /// Runs the className operation.
  String className(String key) {
    final normalized = key.startsWith('.') ? key.substring(1) : key;
    return '${_safeCssIdent(name)}-${_safeCssIdent(normalized)}';
  }

  /// Returns the cssText value.
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

/// Represents the KeyframeStep API in Flint UI.
class KeyframeStep {
  /// The offset value.
  final Object offset;

  /// The style value.
  final DartStyle style;

  /// Creates a KeyframeStep instance.
  const KeyframeStep(this.offset, this.style);

  /// Creates a KeyframeStep instance.
  const KeyframeStep.from(this.style) : offset = 'from';

  /// Creates a KeyframeStep instance.
  const KeyframeStep.to(this.style) : offset = 'to';

  /// Creates a KeyframeStep instance.
  const KeyframeStep.percent(num percent, this.style) : offset = percent;

  /// Returns the selector value.
  String get selector {
    if (offset is num) return '${offset}%';
    return offset.toString();
  }
}

/// Represents the StyleKeyframes API in Flint UI.
class StyleKeyframes {
  /// The name value.
  final String name;

  /// The steps value.
  final List<KeyframeStep> steps;

  /// Creates a StyleKeyframes instance.
  const StyleKeyframes(this.name, this.steps);

  /// Creates a StyleKeyframes instance.
  factory StyleKeyframes.fromTo({
    required String name,
    required DartStyle from,
    required DartStyle to,
  }) {
    return StyleKeyframes(name, [KeyframeStep.from(from), KeyframeStep.to(to)]);
  }

  static StyleKeyframes spin({String name = 'flint-spin'}) {
    return StyleKeyframes.fromTo(
      name: name,
      from: DartStyle(transform: StyleTransform.rotate(0)),
      to: DartStyle(transform: StyleTransform.rotate('360deg')),
    );
  }

  static StyleKeyframes fadeIn({String name = 'flint-fade-in'}) {
    return StyleKeyframes.fromTo(
      name: name,
      from: const DartStyle(opacity: 0),
      to: const DartStyle(opacity: 1),
    );
  }

  /// Returns the cssText value.
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

/// Represents the RootDesign API in Flint UI.
class RootDesign {
  /// The name value.
  final String name;

  /// The theme value.
  final FlintTheme? theme;

  /// The root value.
  final DartStyle? root;

  /// The html value.
  final DartStyle? html;

  /// The body value.
  final DartStyle? body;

  /// The all value.
  final DartStyle? all;

  /// The links value.
  final DartStyle? links;

  /// The selectors value.
  final Map<String, DartStyle> selectors;

  /// The keyframes value.
  final List<StyleKeyframes> keyframes;

  /// Creates a RootDesign instance.
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

  /// Returns the cssText value.
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
