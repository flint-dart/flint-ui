import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// Represents the Stack API in Flint UI.
class Stack extends FlintElement {
  /// Creates a Stack instance.
  Stack({
    Object? child,
    List<Object?> children = const [],
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         'div',
         props: mergeComponentProps(
           props,
           className: className,
           defaultStyle: const {'position': 'relative'},
           dartStyle: dartStyle,
           style: style,
         ),
         children: normalizeChildren(child, children),
       );
}
