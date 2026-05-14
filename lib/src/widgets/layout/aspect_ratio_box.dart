import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// Represents the AspectRatioBox API in Flint UI.
class AspectRatioBox extends FlintElement {
  /// Creates a AspectRatioBox instance.
  AspectRatioBox({
    required Object ratio,
    Object? child,
    List<Object?> children = const [],
    Object? width,
    Object? overflow,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         'div',
         props: mergeComponentProps(
           props,
           className: className,
           dartStyle: DartStyle(
             width: width ?? SizeValue.full,
             aspectRatio: ratio,
             overflow: overflow,
           ).merge(dartStyle),
           style: style,
         ),
         children: normalizeChildren(child, children),
       );

  /// Creates a AspectRatioBox instance.
  AspectRatioBox.square({
    Object? child,
    List<Object?> children = const [],
    Object? width,
    Object? overflow,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : this(
         ratio: '1 / 1',
         child: child,
         children: children,
         width: width,
         overflow: overflow,
         className: className,
         props: props,
         style: style,
         dartStyle: dartStyle,
       );

  /// Creates a AspectRatioBox instance.
  AspectRatioBox.video({
    Object? child,
    List<Object?> children = const [],
    Object? width,
    Object? overflow,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : this(
         ratio: '16 / 9',
         child: child,
         children: children,
         width: width,
         overflow: overflow,
         className: className,
         props: props,
         style: style,
         dartStyle: dartStyle,
       );
}
