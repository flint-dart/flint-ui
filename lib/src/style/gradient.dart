part of '../style.dart';

/// Represents the Gradient API in Flint UI.
class Gradient {
  /// The value value.
  final String value;

  /// Creates a Gradient instance.
  const Gradient(this.value);

  /// Creates a Gradient instance.
  factory Gradient.linear(num angle, List<Object> stops) {
    return Gradient(
      'linear-gradient(${angle}deg, ${stops.map(_gradientStopValue).join(', ')})',
    );
  }

  /// Creates a Gradient instance.
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

  /// Creates a Gradient instance.
  factory Gradient.radial(String shape, List<Object> stops) {
    return Gradient(
      'radial-gradient($shape, ${stops.map(_gradientStopValue).join(', ')})',
    );
  }

  /// Creates a Gradient instance.
  factory Gradient.radialCircle({Object? at, required List<Object> stops}) {
    final shape = at == null ? 'circle' : 'circle at ${cssValue(at)}';
    return Gradient.radial(shape, stops);
  }

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the Background API in Flint UI.
class Background {
  /// The value value.
  final String value;

  /// Creates a Background instance.
  const Background(this.value);

  /// Creates a Background instance.
  factory Background.layers(List<Object> layers) {
    if (layers.isEmpty) {
      throw ArgumentError.value(layers, 'layers', 'Must not be empty.');
    }
    return Background(layers.map(cssValue).join(', '));
  }

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the GradientPosition API in Flint UI.
class GradientPosition {
  /// The value value.
  final String value;

  /// Creates a GradientPosition instance.
  const GradientPosition(this.value);

  /// Creates a GradientPosition instance.
  const GradientPosition.percent(num x, num y) : value = '$x% $y%';

  static const topLeft = GradientPosition('top left');
  static const topRight = GradientPosition('top right');
  static const bottomLeft = GradientPosition('bottom left');
  static const bottomRight = GradientPosition('bottom right');
  static const center = GradientPosition('center');

  @override
  /// Runs the toString operation.
  String toString() => value;
}

/// Represents the Flex API in Flint UI.
class Flex {
  /// The grow value.
  final Object grow;

  /// The shrink value.
  final Object shrink;

  /// The basis value.
  final Object basis;

  /// Creates a Flex instance.
  const Flex(this.grow, this.shrink, this.basis);

  /// Creates a Flex instance.
  const Flex.grow([this.grow = 1]) : shrink = 1, basis = '0%';

  /// Creates a Flex instance.
  const Flex.auto() : grow = 1, shrink = 1, basis = 'auto';

  /// Creates a Flex instance.
  const Flex.none() : grow = 0, shrink = 0, basis = 'auto';

  /// Creates a Flex instance.
  const Flex.fill() : grow = 1, shrink = 1, basis = 'auto';

  /// Runs the toCss operation.
  String toCss() {
    return [
      cssValue(grow, unitlessNumber: true),
      cssValue(shrink, unitlessNumber: true),
      cssValue(basis),
    ].join(' ');
  }

  @override
  /// Runs the toString operation.
  String toString() => toCss();
}

/// Represents the GradientStop API in Flint UI.
class GradientStop {
  /// The color value.
  final Object color;

  /// The position value.
  final Object? position;

  /// Creates a GradientStop instance.
  const GradientStop(this.color, [this.position]);

  /// Runs the toCss operation.
  String toCss() {
    final colorValue = cssValue(color);
    if (position == null) return colorValue;
    return '$colorValue ${_gradientPositionValue(position)}';
  }
}

String _gradientStopValue(Object stop) {
  /// Creates a if instance.
  if (stop is GradientStop) return stop.toCss();
  return cssValue(stop);
}

String _gradientPositionValue(Object? position) {
  /// Creates a if instance.
  if (position is num) {
    final value = position % 1 == 0 ? position.toInt() : position;
    return '$value%';
  }
  return cssValue(position);
}

/// Represents the Gradients API in Flint UI.
class Gradients {
  /// Creates a Gradients instance.
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
