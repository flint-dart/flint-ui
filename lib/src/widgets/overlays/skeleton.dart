import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// Represents the Skeleton API in Flint UI.
class Skeleton extends FlintElement {
  /// Creates a Skeleton instance.
  Skeleton({
    String shape = 'line',
    int lines = 1,
    Object? width,
    Object? height,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         'div',
         props: mergeComponentProps(
           props,
           className: className,
           defaultStyle: const {'display': 'grid', 'gap': '8px'},
           dartStyle: dartStyle,
           style: style,
         ),
         children: [
           for (var i = 0; i < lines; i++)
             FlintElement(
               'span',
               props: {
                 'aria-hidden': 'true',
                 'data-shape': shape,
                 'style': {
                   'display': 'block',
                   'width': width == null ? '100%' : cssValue(width),
                   'height': height == null
                       ? (shape == 'circle' ? '40px' : '12px')
                       : cssValue(height),
                   'border-radius': shape == 'circle' ? '999px' : '6px',
                   'background': '#eaecf0',
                 },
               },
             ),
         ],
       );
}
