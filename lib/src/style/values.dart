part of '../style.dart';

class EdgeInsets {
  final Object? top;
  final Object? right;
  final Object? bottom;
  final Object? left;

  const EdgeInsets.only({
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  const EdgeInsets.all(Object value)
      : top = value,
        right = value,
        bottom = value,
        left = value;

  const EdgeInsets.symmetric({
    Object? vertical,
    Object? horizontal,
  })  : top = vertical,
        right = horizontal,
        bottom = vertical,
        left = horizontal;

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

class SizeValue {
  final String value;

  const SizeValue(this.value);
  const SizeValue.px(num value) : value = '${value}px';
  const SizeValue.percent(num value) : value = '${value}%';
  const SizeValue.rem(num value) : value = '${value}rem';
  const SizeValue.em(num value) : value = '${value}em';

  static const auto = SizeValue('auto');
  static const full = SizeValue('100%');

  @override
  String toString() => value;
}

class Border {
  final Object width;
  final Object color;
  final String style;

  const Border({
    this.width = 1,
    required Object color,
    this.style = 'solid',
  }) : color = color;

  const Border.all({
    Object width = 1,
    required Object color,
    String style = 'solid',
  }) : this(width: width, color: color, style: style);

  String toCss() => '${cssValue(width)} $style ${cssValue(color)}';
}

class Shadow {
  final Object x;
  final Object y;
  final Object blur;
  final Object spread;
  final Object color;
  final bool inset;

  const Shadow({
    this.x = 0,
    this.y = 1,
    this.blur = 2,
    this.spread = 0,
    required this.color,
    this.inset = false,
  });

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

class StyleTransform {
  final String value;

  const StyleTransform(this.value);

  factory StyleTransform.translate({
    Object x = 0,
    Object y = 0,
  }) {
    return StyleTransform('translate(${cssValue(x)}, ${cssValue(y)})');
  }

  factory StyleTransform.translateX(Object value) {
    return StyleTransform('translateX(${cssValue(value)})');
  }

  factory StyleTransform.translateY(Object value) {
    return StyleTransform('translateY(${cssValue(value)})');
  }

  factory StyleTransform.scale(num value) {
    return StyleTransform('scale($value)');
  }

  factory StyleTransform.rotate(Object value) {
    return StyleTransform('rotate(${cssValue(value)})');
  }

  factory StyleTransform.combine(List<StyleTransform> transforms) {
    if (transforms.isEmpty) {
      throw ArgumentError.value(
        transforms,
        'transforms',
        'Must not be empty.',
      );
    }
    return StyleTransform(transforms.map((item) => item.value).join(' '));
  }

  @override
  String toString() => value;
}

class StyleFilter {
  final String value;

  const StyleFilter(this.value);

  factory StyleFilter.blur(Object value) {
    return StyleFilter('blur(${cssValue(value)})');
  }

  factory StyleFilter.saturate(num percent) {
    return StyleFilter('saturate($percent%)');
  }

  factory StyleFilter.brightness(num percent) {
    return StyleFilter('brightness($percent%)');
  }

  factory StyleFilter.contrast(num percent) {
    return StyleFilter('contrast($percent%)');
  }

  factory StyleFilter.combine(List<StyleFilter> filters) {
    if (filters.isEmpty) {
      throw ArgumentError.value(filters, 'filters', 'Must not be empty.');
    }
    return StyleFilter(filters.map((item) => item.value).join(' '));
  }

  @override
  String toString() => value;
}

class FontFamily {
  final String value;

  const FontFamily(this.value);

  static const systemSans = FontFamily(
    'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
  );

  @override
  String toString() => value;
}

class BoxSizing {
  final String value;

  const BoxSizing(this.value);

  static const borderBox = BoxSizing('border-box');
  static const contentBox = BoxSizing('content-box');

  @override
  String toString() => value;
}

class ScrollBehavior {
  final String value;

  const ScrollBehavior(this.value);

  static const auto = ScrollBehavior('auto');
  static const smooth = ScrollBehavior('smooth');

  @override
  String toString() => value;
}

class Cursor {
  final String value;

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
  String toString() => value;
}

class Overflow {
  final String value;

  const Overflow(this.value);

  static const visible = Overflow('visible');
  static const hidden = Overflow('hidden');
  static const clip = Overflow('clip');
  static const scroll = Overflow('scroll');
  static const auto = Overflow('auto');

  @override
  String toString() => value;
}

class ObjectFit {
  final String value;

  const ObjectFit(this.value);

  static const fill = ObjectFit('fill');
  static const contain = ObjectFit('contain');
  static const cover = ObjectFit('cover');
  static const none = ObjectFit('none');
  static const scaleDown = ObjectFit('scale-down');

  @override
  String toString() => value;
}

class TextTransform {
  final String value;

  const TextTransform(this.value);

  static const none = TextTransform('none');
  static const capitalize = TextTransform('capitalize');
  static const uppercase = TextTransform('uppercase');
  static const lowercase = TextTransform('lowercase');

  @override
  String toString() => value;
}

class TextDecorationStyle {
  final String value;

  const TextDecorationStyle(this.value);

  static const none = TextDecorationStyle('none');
  static const underline = TextDecorationStyle('underline');

  @override
  String toString() => value;
}

class FlexWrap {
  final String value;

  const FlexWrap(this.value);

  static const nowrap = FlexWrap('nowrap');
  static const wrap = FlexWrap('wrap');
  static const wrapReverse = FlexWrap('wrap-reverse');

  @override
  String toString() => value;
}

class Resize {
  final String value;

  const Resize(this.value);

  static const none = Resize('none');
  static const both = Resize('both');
  static const horizontal = Resize('horizontal');
  static const vertical = Resize('vertical');
  static const block = Resize('block');
  static const inline = Resize('inline');

  @override
  String toString() => value;
}

class TransitionTiming {
  final String value;

  const TransitionTiming(this.value);

  static const ease = TransitionTiming('ease');
  static const easeIn = TransitionTiming('ease-in');
  static const easeOut = TransitionTiming('ease-out');
  static const easeInOut = TransitionTiming('ease-in-out');
  static const linear = TransitionTiming('linear');

  @override
  String toString() => value;
}

class StyleTransition {
  final String value;

  const StyleTransition(this.value);

  factory StyleTransition.property(
    String property, {
    int milliseconds = 180,
    TransitionTiming timing = TransitionTiming.ease,
  }) {
    return StyleTransition('$property ${milliseconds}ms ${timing.value}');
  }

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

  factory StyleTransition.combine(List<StyleTransition> transitions) {
    if (transitions.isEmpty) {
      throw ArgumentError.value(
        transitions,
        'transitions',
        'Must not be empty.',
      );
    }
    return StyleTransition(
      transitions.map((item) => item.value).join(', '),
    );
  }

  @override
  String toString() => value;
}

class AnimationDirection {
  final String value;

  const AnimationDirection(this.value);

  static const normal = AnimationDirection('normal');
  static const reverse = AnimationDirection('reverse');
  static const alternate = AnimationDirection('alternate');
  static const alternateReverse = AnimationDirection('alternate-reverse');

  @override
  String toString() => value;
}

class AnimationFillMode {
  final String value;

  const AnimationFillMode(this.value);

  static const none = AnimationFillMode('none');
  static const forwards = AnimationFillMode('forwards');
  static const backwards = AnimationFillMode('backwards');
  static const both = AnimationFillMode('both');

  @override
  String toString() => value;
}

class AnimationPlayState {
  final String value;

  const AnimationPlayState(this.value);

  static const running = AnimationPlayState('running');
  static const paused = AnimationPlayState('paused');

  @override
  String toString() => value;
}

class AnimationIteration {
  final Object value;

  const AnimationIteration(this.value);
  const AnimationIteration.count(num count) : value = count;

  static const infinite = AnimationIteration('infinite');

  @override
  String toString() => cssValue(value, unitlessNumber: true);
}

class StyleAnimation {
  final String value;

  const StyleAnimation(this.value);

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

  factory StyleAnimation.combine(List<StyleAnimation> animations) {
    if (animations.isEmpty) {
      throw ArgumentError.value(
        animations,
        'animations',
        'Must not be empty.',
      );
    }
    return StyleAnimation(
      animations.map((item) => item.value).join(', '),
    );
  }

  @override
  String toString() => value;
}

class WillChange {
  final String value;

  const WillChange(this.value);

  static const auto = WillChange('auto');
  static const transform = WillChange('transform');
  static const opacity = WillChange('opacity');
  static const scrollPosition = WillChange('scroll-position');
  static const contents = WillChange('contents');

  factory WillChange.properties(List<Object> properties) {
    if (properties.isEmpty) {
      throw ArgumentError.value(
        properties,
        'properties',
        'Must not be empty.',
      );
    }
    return WillChange(
      properties.map((item) => cssValue(item, unitlessNumber: true)).join(', '),
    );
  }

  @override
  String toString() => value;
}

enum Display {
  block('block'),
  inline('inline'),
  inlineBlock('inline-block'),
  flex('flex'),
  inlineFlex('inline-flex'),
  grid('grid'),
  none('none');

  final String css;
  const Display(this.css);
}

enum FlexDirection {
  row('row'),
  rowReverse('row-reverse'),
  column('column'),
  columnReverse('column-reverse');

  final String css;
  const FlexDirection(this.css);
}

enum AlignItems {
  start('flex-start'),
  center('center'),
  end('flex-end'),
  stretch('stretch'),
  baseline('baseline');

  final String css;
  const AlignItems(this.css);
}

enum JustifyContent {
  start('flex-start'),
  center('center'),
  end('flex-end'),
  between('space-between'),
  around('space-around'),
  evenly('space-evenly');

  final String css;
  const JustifyContent(this.css);
}

enum Position {
  static('static'),
  relative('relative'),
  absolute('absolute'),
  fixed('fixed'),
  sticky('sticky');

  final String css;
  const Position(this.css);
}

enum TextAlign {
  left('left'),
  center('center'),
  right('right'),
  justify('justify');

  final String css;
  const TextAlign(this.css);
}

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
