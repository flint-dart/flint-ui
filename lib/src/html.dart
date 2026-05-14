import 'component.dart';
import 'component_props.dart' as component_props;
import 'node.dart';

FlintElement h(
  String tag, {
  Map<String, Object?> props = const {},
  List<Object?> children = const [],
}) {
  return FlintElement(
    tag,
    props: props,
    children: children.map(component_props.toFlintNode).toList(growable: false),
  );
}

FlintText text(Object? value) => FlintText(value?.toString() ?? '');

FlintFragment fragment(List<Object?> children) {
  return FlintFragment(
    children.map(component_props.toFlintNode).toList(growable: false),
  );
}

FlintComponentNode component(FlintComponent component) {
  return FlintComponentNode(component);
}

FlintNode toFlintNode(Object? value) {
  return component_props.toFlintNode(value);
}

FlintElement div({
  Map<String, Object?> props = const {},
  List<Object?> children = const [],
}) => h('div', props: props, children: children);

FlintElement span({
  Map<String, Object?> props = const {},
  List<Object?> children = const [],
}) => h('span', props: props, children: children);

FlintElement button({
  Map<String, Object?> props = const {},
  List<Object?> children = const [],
}) => h('button', props: props, children: children);

FlintElement input({Map<String, Object?> props = const {}}) =>
    h('input', props: props);
