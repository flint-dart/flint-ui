import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

class Popover extends FlintElement {
  Popover({
    required Object trigger,
    Object? child,
    List<Object?> children = const [],
    bool open = false,
    String placement = 'bottom',
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
          'span',
          props: mergeComponentProps(
            props,
            className: className,
            defaultStyle: const {
              'position': 'relative',
              'display': 'inline-flex'
            },
            dartStyle: dartStyle,
            style: style,
          ),
          children: [
            toFlintNode(trigger),
            FlintElement(
              'div',
              props: {
                if (!open) 'hidden': true,
                'role': 'dialog',
                'data-placement': placement,
                'style': const {
                  'position': 'absolute',
                  'z-index': 30,
                  'min-width': '220px',
                  'padding': '12px',
                  'border': '1px solid #e4e7ec',
                  'border-radius': '8px',
                  'background': '#ffffff',
                  'box-shadow': '0 12px 24px rgba(16, 24, 40, 0.14)',
                },
              },
              children: normalizeChildren(child, children),
            ),
          ],
        );
}
