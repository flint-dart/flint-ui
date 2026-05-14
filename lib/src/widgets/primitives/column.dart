import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// Represents the Column API in Flint UI.
class Column extends FlintElement {
  /// Creates a Column instance.
  Column({
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
           defaultStyle: const {'display': 'flex', 'flex-direction': 'column'},
           dartStyle: dartStyle,
           style: style,
         ),
         children: normalizeChildren(child, children),
       );
}
