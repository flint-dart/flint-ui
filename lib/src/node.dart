import 'component.dart';

sealed class FlintNode {
  const FlintNode();
}

class FlintText extends FlintNode {
  final String value;

  const FlintText(this.value);
}

class FlintFragment extends FlintNode {
  final List<FlintNode> children;

  const FlintFragment(this.children);
}

class FlintElement extends FlintNode {
  final String tag;
  final Map<String, Object?> props;
  final List<FlintNode> children;

  const FlintElement(
    this.tag, {
    this.props = const {},
    this.children = const [],
  });
}

class FlintComponentNode extends FlintNode {
  final FlintComponent component;

  const FlintComponentNode(this.component);
}
