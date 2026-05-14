part of '../style.dart';

/// Typed spacing value for CSS margin and padding.
class EdgeInsets {
  /// Top edge value.
  final Object? top;

  /// Right edge value.
  final Object? right;

  /// Bottom edge value.
  final Object? bottom;

  /// Left edge value.
  final Object? left;

  /// Creates edge values for selected sides.
  const EdgeInsets.only({this.top, this.right, this.bottom, this.left});

  /// Creates equal edge values for every side.
  const EdgeInsets.all(Object value)
    : top = value,
      right = value,
      bottom = value,
      left = value;

  /// Creates vertical and horizontal edge values.
  const EdgeInsets.symmetric({Object? vertical, Object? horizontal})
    : top = vertical,
      right = horizontal,
      bottom = vertical,
      left = horizontal;

  /// Converts this spacing value to a CSS shorthand.
  String toCss() {
    final values = [
      cssValue(top ?? 0),
      cssValue(right ?? 0),
      cssValue(bottom ?? 0),
      cssValue(left ?? 0),
    ];

    if (values.every((value) => value == values.first)) return values.first;
    if (values[0] == values[2] && values[1] == values[3]) {
      return '${values[0]} ${values[1]}';
    }
    if (values[1] == values[3]) {
      return '${values[0]} ${values[1]} ${values[2]}';
    }
    return values.join(' ');
  }
}

/// CSS size value with an explicit unit.
class SizeValue {
  /// CSS size string.
  final String value;

  /// Creates a size from a raw CSS [value].
  const SizeValue(this.value);

  /// Creates a pixel size.
  const SizeValue.px(num value) : value = '${value}px';

  /// Creates a percentage size.
  const SizeValue.percent(num value) : value = '${value}%';

  /// Creates a rem size.
  const SizeValue.rem(num value) : value = '${value}rem';

  /// Creates an em size.
  const SizeValue.em(num value) : value = '${value}em';

  /// CSS `auto` size.
  static const auto = SizeValue('auto');

  /// CSS `100%` size.
  static const full = SizeValue('100%');

  /// Returns the CSS size string.
  @override
  String toString() => value;
}

/// Typed CSS border shorthand value.
class Border {
  /// Border width.
  final Object width;

  /// Border color.
  final Object color;

  /// Border style.
  final String style;

  /// Creates a border shorthand value.
  const Border({this.width = 1, required Object color, this.style = 'solid'})
    : color = color;

  /// Creates a border for all sides.
  const Border.all({
    Object width = 1,
    required Object color,
    String style = 'solid',
  }) : this(width: width, color: color, style: style);

  /// Converts this border to a CSS shorthand.
  String toCss() => '${cssValue(width)} $style ${cssValue(color)}';
}

/// Typed CSS box-shadow value.
class Shadow {
  /// Horizontal shadow offset.
  final Object x;

  /// Vertical shadow offset.
  final Object y;

  /// Shadow blur radius.
  final Object blur;

  /// Shadow spread radius.
  final Object spread;

  /// Shadow color.
  final Object color;

  /// Whether the shadow is inset.
  final bool inset;

  /// Creates a box shadow value.
  const Shadow({
    this.x = 0,
    this.y = 1,
    this.blur = 2,
    this.spread = 0,
    required this.color,
    this.inset = false,
  });

  /// Converts this shadow to a CSS `box-shadow` value.
  String toCss() {
    return [
      if (inset) 'inset',
      cssValue(x),
      cssValue(y),
      cssValue(blur),
      cssValue(spread),
      cssValue(color),
    ].join(' ');
  }
}

/// Typed CSS transform value.
class StyleTransform {
  /// CSS transform string.
  final String value;

  /// Creates a transform from a raw CSS [value].
  const StyleTransform(this.value);

  /// Creates a `translate(...)` transform.
  factory StyleTransform.translate({Object x = 0, Object y = 0}) {
    return StyleTransform('translate(${cssValue(x)}, ${cssValue(y)})');
  }

  /// Creates a `translateX(...)` transform.
  factory StyleTransform.translateX(Object value) {
    return StyleTransform('translateX(${cssValue(value)})');
  }

  /// Creates a `translateY(...)` transform.
  factory StyleTransform.translateY(Object value) {
    return StyleTransform('translateY(${cssValue(value)})');
  }

  /// Creates a `scale(...)` transform.
  factory StyleTransform.scale(num value) {
    return StyleTransform('scale($value)');
  }

  /// Creates a `rotate(...)` transform.
  factory StyleTransform.rotate(Object value) {
    return StyleTransform('rotate(${cssValue(value)})');
  }

  /// Combines multiple transforms into one CSS transform value.
  factory StyleTransform.combine(List<StyleTransform> transforms) {
    if (transforms.isEmpty) {
      throw ArgumentError.value(transforms, 'transforms', 'Must not be empty.');
    }
    return StyleTransform(transforms.map((item) => item.value).join(' '));
  }

  /// Returns the CSS transform string.
  @override
  String toString() => value;
}

/// Typed CSS filter value.
class StyleFilter {
  /// CSS filter string.
  final String value;

  /// Creates a filter from a raw CSS [value].
  const StyleFilter(this.value);

  /// Creates a `blur(...)` filter.
  factory StyleFilter.blur(Object value) {
    return StyleFilter('blur(${cssValue(value)})');
  }

  /// Creates a `saturate(...)` filter.
  factory StyleFilter.saturate(num percent) {
    return StyleFilter('saturate($percent%)');
  }

  /// Creates a `brightness(...)` filter.
  factory StyleFilter.brightness(num percent) {
    return StyleFilter('brightness($percent%)');
  }

  /// Creates a `contrast(...)` filter.
  factory StyleFilter.contrast(num percent) {
    return StyleFilter('contrast($percent%)');
  }

  /// Combines multiple filters into one CSS filter value.
  factory StyleFilter.combine(List<StyleFilter> filters) {
    if (filters.isEmpty) {
      throw ArgumentError.value(filters, 'filters', 'Must not be empty.');
    }
    return StyleFilter(filters.map((item) => item.value).join(' '));
  }

  /// Returns the CSS filter string.
  @override
  String toString() => value;
}

/// CSS font-family value.
class FontFamily {
  /// CSS font-family string.
  final String value;

  /// Creates a font family from a raw CSS [value].
  const FontFamily(this.value);

  /// System sans-serif font stack.
  static const systemSans = FontFamily(
    'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
  );

  /// Returns the CSS font-family string.
  @override
  String toString() => value;
}

/// CSS box-sizing value.
class BoxSizing {
  /// CSS box-sizing string.
  final String value;

  /// Creates a box-sizing value.
  const BoxSizing(this.value);

  /// CSS `border-box`.
  static const borderBox = BoxSizing('border-box');

  /// CSS `content-box`.
  static const contentBox = BoxSizing('content-box');

  /// Returns the CSS box-sizing string.
  @override
  String toString() => value;
}

/// CSS scroll-behavior value.
class ScrollBehavior {
  /// CSS scroll-behavior string.
  final String value;

  /// Creates a scroll behavior value.
  const ScrollBehavior(this.value);

  /// CSS `auto`.
  static const auto = ScrollBehavior('auto');

  /// CSS `smooth`.
  static const smooth = ScrollBehavior('smooth');

  /// Returns the CSS scroll-behavior string.
  @override
  String toString() => value;
}

/// CSS cursor value.
class Cursor {
  /// CSS cursor string.
  final String value;

  /// Creates a cursor value.
  const Cursor(this.value);

  static const auto = Cursor('auto');
  static const defaultCursor = Cursor('default');
  static const pointer = Cursor('pointer');
  static const text = Cursor('text');
  static const move = Cursor('move');
  static const grab = Cursor('grab');
  static const grabbing = Cursor('grabbing');
  static const notAllowed = Cursor('not-allowed');
  static const wait = Cursor('wait');
  static const progress = Cursor('progress');
  static const help = Cursor('help');

  /// Returns the CSS cursor string.
  @override
  String toString() => value;
}

/// CSS overflow value.
class Overflow {
  /// CSS overflow string.
  final String value;

  /// Creates an overflow value.
  const Overflow(this.value);

  static const visible = Overflow('visible');
  static const hidden = Overflow('hidden');
  static const clip = Overflow('clip');
  static const scroll = Overflow('scroll');
  static const auto = Overflow('auto');

  /// Returns the CSS overflow string.
  @override
  String toString() => value;
}

/// CSS object-fit value.
class ObjectFit {
  /// CSS object-fit string.
  final String value;

  /// Creates an object-fit value.
  const ObjectFit(this.value);

  static const fill = ObjectFit('fill');
  static const contain = ObjectFit('contain');
  static const cover = ObjectFit('cover');
  static const none = ObjectFit('none');
  static const scaleDown = ObjectFit('scale-down');

  /// Returns the CSS object-fit string.
  @override
  String toString() => value;
}

/// CSS text-transform value.
class TextTransform {
  /// CSS text-transform string.
  final String value;

  /// Creates a text-transform value.
  const TextTransform(this.value);

  static const none = TextTransform('none');
  static const capitalize = TextTransform('capitalize');
  static const uppercase = TextTransform('uppercase');
  static const lowercase = TextTransform('lowercase');

  /// Returns the CSS text-transform string.
  @override
  String toString() => value;
}

/// CSS text-decoration value.
class TextDecorationStyle {
  /// CSS text-decoration string.
  final String value;

  /// Creates a text-decoration value.
  const TextDecorationStyle(this.value);

  static const none = TextDecorationStyle('none');
  static const underline = TextDecorationStyle('underline');

  /// Returns the CSS text-decoration string.
  @override
  String toString() => value;
}

/// CSS flex-wrap value.
class FlexWrap {
  /// CSS flex-wrap string.
  final String value;

  /// Creates a flex-wrap value.
  const FlexWrap(this.value);

  static const nowrap = FlexWrap('nowrap');
  static const wrap = FlexWrap('wrap');
  static const wrapReverse = FlexWrap('wrap-reverse');

  /// Returns the CSS flex-wrap string.
  @override
  String toString() => value;
}

/// CSS resize value.
class Resize {
  /// CSS resize string.
  final String value;

  /// Creates a resize value.
  const Resize(this.value);

  static const none = Resize('none');
  static const both = Resize('both');
  static const horizontal = Resize('horizontal');
  static const vertical = Resize('vertical');
  static const block = Resize('block');
  static const inline = Resize('inline');

  /// Returns the CSS resize string.
  @override
  String toString() => value;
}

/// CSS transition timing function.
class TransitionTiming {
  /// CSS timing function string.
  final String value;

  /// Creates a transition timing value.
  const TransitionTiming(this.value);

  static const ease = TransitionTiming('ease');
  static const easeIn = TransitionTiming('ease-in');
  static const easeOut = TransitionTiming('ease-out');
  static const easeInOut = TransitionTiming('ease-in-out');
  static const linear = TransitionTiming('linear');

  /// Returns the CSS timing function string.
  @override
  String toString() => value;
}

/// Typed CSS transition value.
class StyleTransition {
  /// CSS transition string.
  final String value;

  /// Creates a transition from a raw CSS [value].
  const StyleTransition(this.value);

  /// Creates a transition for one CSS [property].
  factory StyleTransition.property(
    String property, {
    int milliseconds = 180,
    TransitionTiming timing = TransitionTiming.ease,
  }) {
    return StyleTransition('$property ${milliseconds}ms ${timing.value}');
  }

  /// Creates an `all` transition.
  factory StyleTransition.all({
    int milliseconds = 180,
    TransitionTiming timing = TransitionTiming.ease,
  }) {
    return StyleTransition.property(
      'all',
      milliseconds: milliseconds,
      timing: timing,
    );
  }

  /// Creates transitions for common color-related properties.
  factory StyleTransition.colors({
    int milliseconds = 180,
    TransitionTiming timing = TransitionTiming.ease,
  }) {
    return StyleTransition.combine([
      StyleTransition.property(
        'color',
        milliseconds: milliseconds,
        timing: timing,
      ),
      StyleTransition.property(
        'background',
        milliseconds: milliseconds,
        timing: timing,
      ),
      StyleTransition.property(
        'border-color',
        milliseconds: milliseconds,
        timing: timing,
      ),
    ]);
  }

  /// Creates a transition for CSS transforms.
  factory StyleTransition.transform({
    int milliseconds = 180,
    TransitionTiming timing = TransitionTiming.ease,
  }) {
    return StyleTransition.property(
      'transform',
      milliseconds: milliseconds,
      timing: timing,
    );
  }

  /// Combines multiple transitions into one CSS transition value.
  factory StyleTransition.combine(List<StyleTransition> transitions) {
    if (transitions.isEmpty) {
      throw ArgumentError.value(
        transitions,
        'transitions',
        'Must not be empty.',
      );
    }
    return StyleTransition(transitions.map((item) => item.value).join(', '));
  }

  /// Returns the CSS transition string.
  @override
  String toString() => value;
}

/// CSS animation-direction value.
class AnimationDirection {
  /// CSS animation-direction string.
  final String value;

  /// Creates an animation direction value.
  const AnimationDirection(this.value);

  static const normal = AnimationDirection('normal');
  static const reverse = AnimationDirection('reverse');
  static const alternate = AnimationDirection('alternate');
  static const alternateReverse = AnimationDirection('alternate-reverse');

  /// Returns the CSS animation-direction string.
  @override
  String toString() => value;
}

/// CSS animation-fill-mode value.
class AnimationFillMode {
  /// CSS animation-fill-mode string.
  final String value;

  /// Creates an animation fill mode value.
  const AnimationFillMode(this.value);

  static const none = AnimationFillMode('none');
  static const forwards = AnimationFillMode('forwards');
  static const backwards = AnimationFillMode('backwards');
  static const both = AnimationFillMode('both');

  /// Returns the CSS animation-fill-mode string.
  @override
  String toString() => value;
}

/// CSS animation-play-state value.
class AnimationPlayState {
  /// CSS animation-play-state string.
  final String value;

  /// Creates an animation play state value.
  const AnimationPlayState(this.value);

  static const running = AnimationPlayState('running');
  static const paused = AnimationPlayState('paused');

  /// Returns the CSS animation-play-state string.
  @override
  String toString() => value;
}

/// CSS animation-iteration-count value.
class AnimationIteration {
  /// Iteration count or keyword.
  final Object value;

  /// Creates an animation iteration value.
  const AnimationIteration(this.value);

  /// Creates a numeric iteration count.
  const AnimationIteration.count(num count) : value = count;

  /// CSS `infinite` iteration count.
  static const infinite = AnimationIteration('infinite');

  /// Returns the CSS animation-iteration-count string.
  @override
  String toString() => cssValue(value, unitlessNumber: true);
}

/// Typed CSS animation shorthand value.
class StyleAnimation {
  /// CSS animation string.
  final String value;

  /// Creates an animation from a raw CSS [value].
  const StyleAnimation(this.value);

  /// Creates an animation shorthand for [name].
  factory StyleAnimation.named(
    String name, {
    int milliseconds = 180,
    TransitionTiming timing = TransitionTiming.ease,
    int delayMilliseconds = 0,
    Object iteration = 1,
    AnimationDirection direction = AnimationDirection.normal,
    AnimationFillMode fillMode = AnimationFillMode.none,
    AnimationPlayState playState = AnimationPlayState.running,
  }) {
    return StyleAnimation(
      [
        name,
        '${milliseconds}ms',
        timing,
        if (delayMilliseconds > 0) '${delayMilliseconds}ms',
        cssValue(iteration, unitlessNumber: true),
        direction,
        fillMode,
        playState,
      ].map((item) => item.toString()).join(' '),
    );
  }

  /// Creates an infinitely repeating animation.
  factory StyleAnimation.infinite(
    String name, {
    int milliseconds = 180,
    TransitionTiming timing = TransitionTiming.linear,
  }) {
    return StyleAnimation.named(
      name,
      milliseconds: milliseconds,
      timing: timing,
      iteration: AnimationIteration.infinite,
    );
  }

  /// Creates the built-in `flint-fade-in` animation.
  factory StyleAnimation.fadeIn({
    int milliseconds = 180,
    TransitionTiming timing = TransitionTiming.easeOut,
  }) {
    return StyleAnimation.named(
      'flint-fade-in',
      milliseconds: milliseconds,
      timing: timing,
      fillMode: AnimationFillMode.both,
    );
  }

  /// Creates the built-in `flint-spin` animation.
  factory StyleAnimation.spin({
    int milliseconds = 800,
    TransitionTiming timing = TransitionTiming.linear,
  }) {
    return StyleAnimation.infinite(
      'flint-spin',
      milliseconds: milliseconds,
      timing: timing,
    );
  }

  /// Combines multiple animations into one CSS animation value.
  factory StyleAnimation.combine(List<StyleAnimation> animations) {
    if (animations.isEmpty) {
      throw ArgumentError.value(animations, 'animations', 'Must not be empty.');
    }
    return StyleAnimation(animations.map((item) => item.value).join(', '));
  }

  /// Returns the CSS animation string.
  @override
  String toString() => value;
}

/// CSS will-change value.
class WillChange {
  /// CSS will-change string.
  final String value;

  /// Creates a will-change value.
  const WillChange(this.value);

  static const auto = WillChange('auto');
  static const transform = WillChange('transform');
  static const opacity = WillChange('opacity');
  static const scrollPosition = WillChange('scroll-position');
  static const contents = WillChange('contents');

  /// Creates a comma-separated list of properties expected to change.
  factory WillChange.properties(List<Object> properties) {
    if (properties.isEmpty) {
      throw ArgumentError.value(properties, 'properties', 'Must not be empty.');
    }
    return WillChange(
      properties.map((item) => cssValue(item, unitlessNumber: true)).join(', '),
    );
  }

  /// Returns the CSS will-change string.
  @override
  String toString() => value;
}

/// CSS display values.
enum Display {
  /// CSS `block`.
  block('block'),

  /// CSS `inline`.
  inline('inline'),

  /// CSS `inline-block`.
  inlineBlock('inline-block'),

  /// CSS `flex`.
  flex('flex'),

  /// CSS `inline-flex`.
  inlineFlex('inline-flex'),

  /// CSS `grid`.
  grid('grid'),

  /// CSS `none`.
  none('none');

  /// CSS keyword emitted for this value.
  final String css;

  /// Creates a display enum value.
  const Display(this.css);
}

/// CSS flex-direction values.
enum FlexDirection {
  /// CSS `row`.
  row('row'),

  /// CSS `row-reverse`.
  rowReverse('row-reverse'),

  /// CSS `column`.
  column('column'),

  /// CSS `column-reverse`.
  columnReverse('column-reverse');

  /// CSS keyword emitted for this value.
  final String css;

  /// Creates a flex-direction enum value.
  const FlexDirection(this.css);
}

/// CSS align-items values.
enum AlignItems {
  /// CSS `flex-start`.
  start('flex-start'),

  /// CSS `center`.
  center('center'),

  /// CSS `flex-end`.
  end('flex-end'),

  /// CSS `stretch`.
  stretch('stretch'),

  /// CSS `baseline`.
  baseline('baseline');

  /// CSS keyword emitted for this value.
  final String css;

  /// Creates an align-items enum value.
  const AlignItems(this.css);
}

/// CSS justify-content values.
enum JustifyContent {
  /// CSS `flex-start`.
  start('flex-start'),

  /// CSS `center`.
  center('center'),

  /// CSS `flex-end`.
  end('flex-end'),

  /// CSS `space-between`.
  between('space-between'),

  /// CSS `space-around`.
  around('space-around'),

  /// CSS `space-evenly`.
  evenly('space-evenly');

  /// CSS keyword emitted for this value.
  final String css;

  /// Creates a justify-content enum value.
  const JustifyContent(this.css);
}

/// CSS position values.
enum Position {
  /// CSS `static`.
  static('static'),

  /// CSS `relative`.
  relative('relative'),

  /// CSS `absolute`.
  absolute('absolute'),

  /// CSS `fixed`.
  fixed('fixed'),

  /// CSS `sticky`.
  sticky('sticky');

  /// CSS keyword emitted for this value.
  final String css;

  /// Creates a position enum value.
  const Position(this.css);
}

/// CSS text-align values.
enum TextAlign {
  /// CSS `left`.
  left('left'),

  /// CSS `center`.
  center('center'),

  /// CSS `right`.
  right('right'),

  /// CSS `justify`.
  justify('justify');

  /// CSS keyword emitted for this value.
  final String css;

  /// Creates a text-align enum value.
  const TextAlign(this.css);
}

/// Converts typed style values into CSS strings.
String cssValue(Object? value, {bool unitlessNumber = false}) {
  if (value == null) return '';

  if (value is TokenRef) return value.toCss();

  if (value is SizeValue) return value.value;

  if (value is Flex) return value.toCss();

  if (value is Border) return value.toCss();

  if (value is Shadow) return value.toCss();

  if (value is num) return unitlessNumber ? value.toString() : '${value}px';
  return value.toString();
}

Map<String, Object?> _withoutNulls(Map<String, Object?> map) {
  return {
    for (final entry in map.entries)
      if (entry.value != null && entry.value != '') entry.key: entry.value,
  };
}

String _safeCssIdent(String value) {
  final safe = value
      .trim()
      .replaceAll(RegExp(r'[^a-zA-Z0-9_-]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return safe.isEmpty ? 'style' : safe;
}
