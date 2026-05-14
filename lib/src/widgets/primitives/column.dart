import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// Vertical flex container.
class Column extends FlintElement {
  /// Creates a column with optional child content and styles.
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
