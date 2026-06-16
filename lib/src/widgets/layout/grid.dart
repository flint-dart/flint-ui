import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// CSS grid container with optional template and alignment controls.
class Grid extends FlintElement {
  /// Creates a grid around child content.
  ///
  /// - [columns] sets the default CSS `grid-template-columns` template. Accepts
  ///   raw CSS strings, size values, or [GridTemplateColumns] instances.
  /// - [sm], [md], [lg], [xl] define responsive overrides for [columns] at each
  ///   respective viewport breakpoint.
  /// - [rows] sets the CSS `grid-template-rows` template.
  /// - [gap] sets the CSS `gap` spacing between grid items.
  /// - [alignItems] sets the CSS `align-items` grid container alignment.
  /// - [justifyItems] sets the CSS `justify-items` grid container alignment.
  Grid({
    Object? child,
    List<Object?> children = const [],
    Object? columns,
    Object? sm,
    Object? md,
    Object? lg,
    Object? xl,
    Object? rows,
    Object? gap,
    String? alignItems,
    String? justifyItems,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         'div',
         props: mergeComponentProps(
           props,
           className: className,
           defaultStyle: {
             'display': 'grid',
             if (columns != null) 'grid-template-columns': cssValue(columns),
             if (rows != null) 'grid-template-rows': cssValue(rows),
             if (gap != null) 'gap': cssValue(gap),
             if (alignItems != null) 'align-items': alignItems,
             if (justifyItems != null) 'justify-items': justifyItems,
           },
           dartStyle: DartStyle(
             sm: sm == null ? null : DartStyle(gridTemplateColumns: sm),
             md: md == null ? null : DartStyle(gridTemplateColumns: md),
             lg: lg == null ? null : DartStyle(gridTemplateColumns: lg),
             xl: xl == null ? null : DartStyle(gridTemplateColumns: xl),
           ).merge(dartStyle),
           style: style,
         ),
         children: normalizeChildren(child, children),
       );
}
