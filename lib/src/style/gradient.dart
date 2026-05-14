part of '../style.dart';

class Gradient {
  final String value;

  const Gradient(this.value);

  factory Gradient.linear(num angle, List<Object> stops) {
    return Gradient(
      'linear-gradient(${angle}deg, ${stops.map(_gradientStopValue).join(', ')})',
    );
  }

  factory Gradient.linearColors(num angle, List<Object> colors) {
    if (colors.isEmpty) {
      throw ArgumentError.value(colors, 'colors', 'Must not be empty.');
    }
    final lastIndex = colors.length - 1;
    final stops = [
      for (var index = 0; index < colors.length; index++)
        GradientStop(
          colors[index],
          lastIndex == 0 ? 0 : (index / lastIndex) * 100,
        ),
    ];

    return Gradient.linear(angle, stops);
  }

  factory Gradient.radial(String shape, List<Object> stops) {
    return Gradient(
      'radial-gradient($shape, ${stops.map(_gradientStopValue).join(', ')})',
    );
  }

  factory Gradient.radialCircle({Object? at, required List<Object> stops}) {
    final shape = at == null ? 'circle' : 'circle at ${cssValue(at)}';
    return Gradient.radial(shape, stops);
  }

  @override
  String toString() => value;
}

class Background {
  final String value;

  const Background(this.value);

  factory Background.layers(List<Object> layers) {
    if (layers.isEmpty) {
      throw ArgumentError.value(layers, 'layers', 'Must not be empty.');
    }
    return Background(layers.map(cssValue).join(', '));
  }

  @override
  String toString() => value;
}

class GradientPosition {
  final String value;

  const GradientPosition(this.value);

  const GradientPosition.percent(num x, num y) : value = '$x% $y%';

  static const topLeft = GradientPosition('top left');
  static const topRight = GradientPosition('top right');
  static const bottomLeft = GradientPosition('bottom left');
  static const bottomRight = GradientPosition('bottom right');
  static const center = GradientPosition('center');

  @override
  String toString() => value;
}

class Flex {
  final Object grow;
  final Object shrink;
  final Object basis;

  const Flex(this.grow, this.shrink, this.basis);

  const Flex.grow([this.grow = 1]) : shrink = 1, basis = '0%';

  const Flex.auto() : grow = 1, shrink = 1, basis = 'auto';

  const Flex.none() : grow = 0, shrink = 0, basis = 'auto';

  const Flex.fill() : grow = 1, shrink = 1, basis = 'auto';

  String toCss() {
    return [
      cssValue(grow, unitlessNumber: true),
      cssValue(shrink, unitlessNumber: true),
      cssValue(basis),
    ].join(' ');
  }

  @override
  String toString() => toCss();
}

class GradientStop {
  final Object color;
  final Object? position;

  const GradientStop(this.color, [this.position]);

  String toCss() {
    final colorValue = cssValue(color);
    if (position == null) return colorValue;
    return '$colorValue ${_gradientPositionValue(position)}';
  }
}

String _gradientStopValue(Object stop) {
  if (stop is GradientStop) return stop.toCss();
  return cssValue(stop);
}

String _gradientPositionValue(Object? position) {
  if (position is num) {
    final value = position % 1 == 0 ? position.toInt() : position;
    return '$value%';
  }
  return cssValue(position);
}

class Gradients {
  const Gradients._();

  static const ocean = Gradient(
    'linear-gradient(135deg, #0ea5e9 0%, #2563eb 58%, #1d4ed8 100%)',
  );

  static const sky = Gradient(
    'linear-gradient(135deg, #2563eb 0%, #0ea5e9 100%)',
  );

  static const softPanel = Gradient(
    'radial-gradient(circle at top left, rgba(56, 189, 248, 0.22), transparent 34%), '
    'radial-gradient(circle at bottom right, rgba(37, 99, 235, 0.18), transparent 32%), '
    'linear-gradient(135deg, #f8fbff 0%, #eef6ff 44%, #ffffff 100%)',
  );
}
