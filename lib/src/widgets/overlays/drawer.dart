import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

class Drawer extends FlintElement {
  Drawer({
    required bool open,
    String? title,
    Object? child,
    List<Object?> children = const [],
    String side = 'right',
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
    void Function(Object event)? onClose,
  }) : super(
          'aside',
          props: mergeComponentProps(
            {
              ...props,
              if (!open) 'hidden': true,
              'role': 'dialog',
              'aria-modal': 'true',
              if (title != null) 'aria-label': title,
            },
            className: className,
            defaultStyle: {
              'position': 'fixed',
              'top': 0,
              'bottom': 0,
              side == 'left' ? 'left' : 'right': 0,
              'z-index': 1000,
              'width': '380px',
              'max-width': '100%',
              'background': '#ffffff',
              'box-shadow': '0 20px 40px rgba(16, 24, 40, 0.18)',
              'display': 'grid',
              'grid-template-rows': 'auto minmax(0, 1fr)',
            },
            dartStyle: dartStyle,
            style: style,
          ),
          children: [
            if (title != null || onClose != null)
              FlintElement(
                'header',
                props: const {
                  'style': {
                    'padding': '16px',
                    'border-bottom': '1px solid #e4e7ec'
                  }
                },
                children: [
                  if (title != null) FlintText(title),
                  if (onClose != null)
                    FlintElement(
                      'button',
                      props: {
                        'type': 'button',
                        'aria-label': 'Close',
                        'onClick': onClose
                      },
                      children: const [FlintText('x')],
                    ),
                ],
              ),
            FlintElement(
              'div',
              props: const {
                'style': {'padding': '16px', 'overflow': 'auto'}
              },
              children: normalizeChildren(child, children),
            ),
          ],
        );
}
