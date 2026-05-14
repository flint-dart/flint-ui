import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// Represents the Row API in Flint UI.
class Row extends FlintElement {
  /// Creates a Row instance.
  Row({
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
           defaultStyle: const {'display': 'flex', 'flex-direction': 'row'},
           dartStyle: dartStyle,
           style: style,
         ),
         children: normalizeChildren(child, children),
       );
}
