part of '../style.dart';

/// Represents the EdgeInsets API in Flint UI.
class EdgeInsets {
  /// The top value.
  final Object? top;

  /// The right value.
  final Object? right;

  /// The bottom value.
  final Object? bottom;

  /// The left value.
  final Object? left;

  /// Creates a EdgeInsets instance.
  const EdgeInsets.only({this.top, this.right, this.bottom, this.left});

  /// Creates a EdgeInsets instance.
  const EdgeInsets.all(Object value)
    : top = value,
      right = value,
      bottom = value,
      left = value;

  /// Creates a EdgeInsets instance.
  const EdgeInsets.symmetric({Object? vertical, Object? horizontal})
    : top = vertical,
      right = horizontal,
      bottom = vertical,
      left = horizontal;

  /// Runs the toCss operation.
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

/// Represents the SizeValue API in Flint UI.
class SizeValue {
  /// The value value.
  final String value;

  /// Creates a SizeValue instance.
  const SizeValue(this.value);

  /// Creates a SizeValue instance.
  const SizeValue.px(num value) : value = '${value}px';

  /// Creates a SizeValue instance.
  const SizeValue.percent(num value) : value = '${value}%';

  /// Creates a SizeValue instance.
  const SizeValue.rem(num value) : value = '${value}rem';

  /// Creates a SizeValue instance.
  const SizeValue.em(num value) : value = '${value}em';

  static const auto = SizeValue('auto');
  static const full = SizeValue('100%');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the Border API in Flint UI.
class Border {
  /// The width value.
  final Object width;

  /// The color value.
  final Object color;

  /// The style value.
  final String style;

  /// Creates a Border instance.
  const Border({this.width = 1, required Object color, this.style = 'solid'})
    : color = color;

  /// Creates a Border instance.
  const Border.all({
    Object width = 1,
    required Object color,
    String style = 'solid',
  }) : this(width: width, color: color, style: style);

  /// Runs the toCss operation.
  String toCss() => '${cssValue(width)} $style ${cssValue(color)}';
}

/// Represents the Shadow API in Flint UI.
class Shadow {
  /// The x value.
  final Object x;

  /// The y value.
  final Object y;

  /// The blur value.
  final Object blur;

  /// The spread value.
  final Object spread;

  /// The color value.
  final Object color;

  /// The inset value.
  final bool inset;

  /// Creates a Shadow instance.
  const Shadow({
    this.x = 0,
    this.y = 1,
    this.blur = 2,
    this.spread = 0,
    required this.color,
    this.inset = false,
  });

  /// Runs the toCss operation.
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

/// Represents the StyleTransform API in Flint UI.
class StyleTransform {
  /// The value value.
  final String value;

  /// Creates a StyleTransform instance.
  const StyleTransform(this.value);

  /// Creates a StyleTransform instance.
  factory StyleTransform.translate({Object x = 0, Object y = 0}) {
    return StyleTransform('translate(${cssValue(x)}, ${cssValue(y)})');
  }

  /// Creates a StyleTransform instance.
  factory StyleTransform.translateX(Object value) {
    return StyleTransform('translateX(${cssValue(value)})');
  }

  /// Creates a StyleTransform instance.
  factory StyleTransform.translateY(Object value) {
    return StyleTransform('translateY(${cssValue(value)})');
  }

  /// Creates a StyleTransform instance.
  factory StyleTransform.scale(num value) {
    return StyleTransform('scale($value)');
  }

  /// Creates a StyleTransform instance.
  factory StyleTransform.rotate(Object value) {
    return StyleTransform('rotate(${cssValue(value)})');
  }

  /// Creates a StyleTransform instance.
  factory StyleTransform.combine(List<StyleTransform> transforms) {
    if (transforms.isEmpty) {
      throw ArgumentError.value(transforms, 'transforms', 'Must not be empty.');
    }
    return StyleTransform(transforms.map((item) => item.value).join(' '));
  }

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the StyleFilter API in Flint UI.
class StyleFilter {
  /// The value value.
  final String value;

  /// Creates a StyleFilter instance.
  const StyleFilter(this.value);

  /// Creates a StyleFilter instance.
  factory StyleFilter.blur(Object value) {
    return StyleFilter('blur(${cssValue(value)})');
  }

  /// Creates a StyleFilter instance.
  factory StyleFilter.saturate(num percent) {
    return StyleFilter('saturate($percent%)');
  }

  /// Creates a StyleFilter instance.
  factory StyleFilter.brightness(num percent) {
    return StyleFilter('brightness($percent%)');
  }

  /// Creates a StyleFilter instance.
  factory StyleFilter.contrast(num percent) {
    return StyleFilter('contrast($percent%)');
  }

  /// Creates a StyleFilter instance.
  factory StyleFilter.combine(List<StyleFilter> filters) {
    if (filters.isEmpty) {
      throw ArgumentError.value(filters, 'filters', 'Must not be empty.');
    }
    return StyleFilter(filters.map((item) => item.value).join(' '));
  }

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the FontFamily API in Flint UI.
class FontFamily {
  /// The value value.
  final String value;

  /// Creates a FontFamily instance.
  const FontFamily(this.value);

  static const systemSans = FontFamily(
    'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
  );

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the BoxSizing API in Flint UI.
class BoxSizing {
  /// The value value.
  final String value;

  /// Creates a BoxSizing instance.
  const BoxSizing(this.value);

  static const borderBox = BoxSizing('border-box');
  static const contentBox = BoxSizing('content-box');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the ScrollBehavior API in Flint UI.
class ScrollBehavior {
  /// The value value.
  final String value;

  /// Creates a ScrollBehavior instance.
  const ScrollBehavior(this.value);

  static const auto = ScrollBehavior('auto');
  static const smooth = ScrollBehavior('smooth');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the Cursor API in Flint UI.
class Cursor {
  /// The value value.
  final String value;

  /// Creates a Cursor instance.
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

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the Overflow API in Flint UI.
class Overflow {
  /// The value value.
  final String value;

  /// Creates a Overflow instance.
  const Overflow(this.value);

  static const visible = Overflow('visible');
  static const hidden = Overflow('hidden');
  static const clip = Overflow('clip');
  static const scroll = Overflow('scroll');
  static const auto = Overflow('auto');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the ObjectFit API in Flint UI.
class ObjectFit {
  /// The value value.
  final String value;

  /// Creates a ObjectFit instance.
  const ObjectFit(this.value);

  static const fill = ObjectFit('fill');
  static const contain = ObjectFit('contain');
  static const cover = ObjectFit('cover');
  static const none = ObjectFit('none');
  static const scaleDown = ObjectFit('scale-down');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the TextTransform API in Flint UI.
class TextTransform {
  /// The value value.
  final String value;

  /// Creates a TextTransform instance.
  const TextTransform(this.value);

  static const none = TextTransform('none');
  static const capitalize = TextTransform('capitalize');
  static const uppercase = TextTransform('uppercase');
  static const lowercase = TextTransform('lowercase');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the TextDecorationStyle API in Flint UI.
class TextDecorationStyle {
  /// The value value.
  final String value;

  /// Creates a TextDecorationStyle instance.
  const TextDecorationStyle(this.value);

  static const none = TextDecorationStyle('none');
  static const underline = TextDecorationStyle('underline');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the FlexWrap API in Flint UI.
class FlexWrap {
  /// The value value.
  final String value;

  /// Creates a FlexWrap instance.
  const FlexWrap(this.value);

  static const nowrap = FlexWrap('nowrap');
  static const wrap = FlexWrap('wrap');
  static const wrapReverse = FlexWrap('wrap-reverse');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the Resize API in Flint UI.
class Resize {
  /// The value value.
  final String value;

  /// Creates a Resize instance.
  const Resize(this.value);

  static const none = Resize('none');
  static const both = Resize('both');
  static const horizontal = Resize('horizontal');
  static const vertical = Resize('vertical');
  static const block = Resize('block');
  static const inline = Resize('inline');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the TransitionTiming API in Flint UI.
class TransitionTiming {
  /// The value value.
  final String value;

  /// Creates a TransitionTiming instance.
  const TransitionTiming(this.value);

  static const ease = TransitionTiming('ease');
  static const easeIn = TransitionTiming('ease-in');
  static const easeOut = TransitionTiming('ease-out');
  static const easeInOut = TransitionTiming('ease-in-out');
  static const linear = TransitionTiming('linear');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the StyleTransition API in Flint UI.
class StyleTransition {
  /// The value value.
  final String value;

  /// Creates a StyleTransition instance.
  const StyleTransition(this.value);

  /// Creates a StyleTransition instance.
  factory StyleTransition.property(
    String property, {
    int milliseconds = 180,
    TransitionTiming timing = TransitionTiming.ease,
  }) {
    return StyleTransition('$property ${milliseconds}ms ${timing.value}');
  }

  /// Creates a StyleTransition instance.
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

  /// Creates a StyleTransition instance.
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

  /// Creates a StyleTransition instance.
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

  /// Creates a StyleTransition instance.
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

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the AnimationDirection API in Flint UI.
class AnimationDirection {
  /// The value value.
  final String value;

  /// Creates a AnimationDirection instance.
  const AnimationDirection(this.value);

  static const normal = AnimationDirection('normal');
  static const reverse = AnimationDirection('reverse');
  static const alternate = AnimationDirection('alternate');
  static const alternateReverse = AnimationDirection('alternate-reverse');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the AnimationFillMode API in Flint UI.
class AnimationFillMode {
  /// The value value.
  final String value;

  /// Creates a AnimationFillMode instance.
  const AnimationFillMode(this.value);

  static const none = AnimationFillMode('none');
  static const forwards = AnimationFillMode('forwards');
  static const backwards = AnimationFillMode('backwards');
  static const both = AnimationFillMode('both');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the AnimationPlayState API in Flint UI.
class AnimationPlayState {
  /// The value value.
  final String value;

  /// Creates a AnimationPlayState instance.
  const AnimationPlayState(this.value);

  static const running = AnimationPlayState('running');
  static const paused = AnimationPlayState('paused');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the AnimationIteration API in Flint UI.
class AnimationIteration {
  /// The value value.
  final Object value;

  /// Creates a AnimationIteration instance.
  const AnimationIteration(this.value);

  /// Creates a AnimationIteration instance.
  const AnimationIteration.count(num count) : value = count;

  static const infinite = AnimationIteration('infinite');

  @override
  /// Runs the toString operation.
  String toString() => cssValue(value, unitlessNumber: true);
}

/// Represents the StyleAnimation API in Flint UI.
class StyleAnimation {
  /// The value value.
  final String value;

  /// Creates a StyleAnimation instance.
  const StyleAnimation(this.value);

  /// Creates a StyleAnimation instance.
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

  /// Creates a StyleAnimation instance.
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

  /// Creates a StyleAnimation instance.
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

  /// Creates a StyleAnimation instance.
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

  /// Creates a StyleAnimation instance.
  factory StyleAnimation.combine(List<StyleAnimation> animations) {
    if (animations.isEmpty) {
      throw ArgumentError.value(animations, 'animations', 'Must not be empty.');
    }
    return StyleAnimation(animations.map((item) => item.value).join(', '));
  }

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the WillChange API in Flint UI.
class WillChange {
  /// The value value.
  final String value;

  /// Creates a WillChange instance.
  const WillChange(this.value);

  static const auto = WillChange('auto');
  static const transform = WillChange('transform');
  static const opacity = WillChange('opacity');
  static const scrollPosition = WillChange('scroll-position');
  static const contents = WillChange('contents');

  /// Creates a WillChange instance.
  factory WillChange.properties(List<Object> properties) {
    if (properties.isEmpty) {
      throw ArgumentError.value(properties, 'properties', 'Must not be empty.');
    }
    return WillChange(
      properties.map((item) => cssValue(item, unitlessNumber: true)).join(', '),
    );
  }

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Options for the Display API.
enum Display {
  /// Creates a block instance.
  block('block'),

  /// Creates a inline instance.
  inline('inline'),

  /// Creates a inlineBlock instance.
  inlineBlock('inline-block'),

  /// Creates a flex instance.
  flex('flex'),

  /// Creates a inlineFlex instance.
  inlineFlex('inline-flex'),

  /// Creates a grid instance.
  grid('grid'),

  /// Creates a none instance.
  none('none');

  /// The css value.
  final String css;

  /// Creates a Display instance.
  const Display(this.css);
}

/// Options for the FlexDirection API.
enum FlexDirection {
  /// Creates a row instance.
  row('row'),

  /// Creates a rowReverse instance.
  rowReverse('row-reverse'),

  /// Creates a column instance.
  column('column'),

  /// Creates a columnReverse instance.
  columnReverse('column-reverse');

  /// The css value.
  final String css;

  /// Creates a FlexDirection instance.
  const FlexDirection(this.css);
}

/// Options for the AlignItems API.
enum AlignItems {
  /// Creates a start instance.
  start('flex-start'),

  /// Creates a center instance.
  center('center'),

  /// Creates a end instance.
  end('flex-end'),

  /// Creates a stretch instance.
  stretch('stretch'),

  /// Creates a baseline instance.
  baseline('baseline');

  /// The css value.
  final String css;

  /// Creates a AlignItems instance.
  const AlignItems(this.css);
}

/// Options for the JustifyContent API.
enum JustifyContent {
  /// Creates a start instance.
  start('flex-start'),

  /// Creates a center instance.
  center('center'),

  /// Creates a end instance.
  end('flex-end'),

  /// Creates a between instance.
  between('space-between'),

  /// Creates a around instance.
  around('space-around'),

  /// Creates a evenly instance.
  evenly('space-evenly');

  /// The css value.
  final String css;

  /// Creates a JustifyContent instance.
  const JustifyContent(this.css);
}

/// Options for the Position API.
enum Position {
  /// Creates a static instance.
  static('static'),

  /// Creates a relative instance.
  relative('relative'),

  /// Creates a absolute instance.
  absolute('absolute'),

  /// Creates a fixed instance.
  fixed('fixed'),

  /// Creates a sticky instance.
  sticky('sticky');

  /// The css value.
  final String css;

  /// Creates a Position instance.
  const Position(this.css);
}

/// Options for the TextAlign API.
enum TextAlign {
  /// Creates a left instance.
  left('left'),

  /// Creates a center instance.
  center('center'),

  /// Creates a right instance.
  right('right'),

  /// Creates a justify instance.
  justify('justify');

  /// The css value.
  final String css;

  /// Creates a TextAlign instance.
  const TextAlign(this.css);
}

String cssValue(Object? value, {bool unitlessNumber = false}) {
  /// Creates a if instance.
  if (value == null) return '';

  /// Creates a if instance.
  if (value is TokenRef) return value.toCss();

  /// Creates a if instance.
  if (value is SizeValue) return value.value;

  /// Creates a if instance.
  if (value is Flex) return value.toCss();

  /// Creates a if instance.
  if (value is Border) return value.toCss();

  /// Creates a if instance.
  if (value is Shadow) return value.toCss();

  /// Creates a if instance.
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
