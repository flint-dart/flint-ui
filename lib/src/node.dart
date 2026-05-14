import 'component.dart';

sealed class FlintNode {
  /// Creates a FlintNode instance.
  const FlintNode();
}

/// Represents the FlintText API in Flint UI.
class FlintText extends FlintNode {
  /// The value value.
  final String value;

  /// Creates a FlintText instance.
  const FlintText(this.value);
}

/// Represents the FlintFragment API in Flint UI.
class FlintFragment extends FlintNode {
  /// The children value.
  final List<FlintNode> children;

  /// Creates a FlintFragment instance.
  const FlintFragment(this.children);
}

/// Represents the FlintElement API in Flint UI.
class FlintElement extends FlintNode {
  /// The tag value.
  final String tag;

  /// The props value.
  final Map<String, Object?> props;

  /// The children value.
  final List<FlintNode> children;

  /// Creates a FlintElement instance.
  const FlintElement(
    this.tag, {
    this.props = const {},
    this.children = const [],
  });
}

/// Represents the FlintComponentNode API in Flint UI.
class FlintComponentNode extends FlintNode {
  /// The component value.
  final FlintComponent component;

  /// Creates a FlintComponentNode instance.
  const FlintComponentNode(this.component);
}
