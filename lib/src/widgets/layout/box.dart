import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// Represents the Box API in Flint UI.
class Box extends FlintElement {
  /// Creates a Box instance.
  Box({
    Object? child,
    List<Object?> children = const [],
    String tag = 'div',
    Object? width,
    Object? height,
    Object? padding,
    Object? margin,
    Object? background,
    Object? radius,
    Border? border,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         tag,
         props: mergeComponentProps(
           props,
           className: className,
           dartStyle: DartStyle(
             width: width,
             height: height,
             padding: padding == null ? null : EdgeInsets.all(padding),
             margin: margin == null ? null : EdgeInsets.all(margin),
             background: background,
             radius: radius,
             border: border,
           ).merge(dartStyle),
           style: style,
         ),
         children: normalizeChildren(child, children),
       );
}
