import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// Represents the ResponsiveGrid API in Flint UI.
class ResponsiveGrid extends FlintElement {
  /// Creates a ResponsiveGrid instance.
  ResponsiveGrid({
    Object? child,
    List<Object?> children = const [],
    int minItemWidth = 240,
    Object? gap,
    Object? rowGap,
    Object? columnGap,
    String? columns,
    String? sm,
    String? md,
    String? lg,
    String? xl,
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
             display: Display.grid,
             gap: gap,
             gridTemplateColumns:
                 columns ?? 'repeat(auto-fit, minmax(${minItemWidth}px, 1fr))',
             sm: sm == null ? null : DartStyle(gridTemplateColumns: sm),
             md: md == null ? null : DartStyle(gridTemplateColumns: md),
             lg: lg == null ? null : DartStyle(gridTemplateColumns: lg),
             xl: xl == null ? null : DartStyle(gridTemplateColumns: xl),
           ).merge(dartStyle),
           style: {
             if (rowGap != null) 'row-gap': cssValue(rowGap),
             if (columnGap != null) 'column-gap': cssValue(columnGap),
             ...style,
           },
         ),
         children: normalizeChildren(child, children),
       );
}
