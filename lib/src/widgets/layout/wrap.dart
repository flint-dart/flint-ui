import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// Represents the Wrap API in Flint UI.
class Wrap extends FlintElement {
  /// Creates a Wrap instance.
  Wrap({
    Object? child,
    List<Object?> children = const [],
    Object? gap,
    AlignItems? alignItems,
    JustifyContent? justifyContent,
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
             'display': 'flex',
             'flex-wrap': cssValue(FlexWrap.wrap, unitlessNumber: true),
             if (gap != null) 'gap': cssValue(gap),
             if (alignItems != null) 'align-items': alignItems.css,
             if (justifyContent != null) 'justify-content': justifyContent.css,
           },
           dartStyle: dartStyle,
           style: style,
         ),
         children: normalizeChildren(child, children),
       );
}
