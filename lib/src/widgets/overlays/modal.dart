import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

class Modal extends FlintElement {
  Modal({
    required bool open,
    String? title,
    Object? child,
    List<Object?> children = const [],
    Object? actions,
    String size = 'md',
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
    void Function(Object event)? onClose,
  }) : super(
          'div',
          props: mergeComponentProps(
            {
              ...props,
              if (!open) 'hidden': true,
              'role': 'dialog',
              'aria-modal': 'true',
              if (title != null) 'aria-label': title,
            },
            className: className,
            defaultStyle: const {
              'position': 'fixed',
              'inset': 0,
              'z-index': 1000,
              'display': 'grid',
              'place-items': 'center',
              'padding': '20px',
              'background': 'rgba(16, 24, 40, 0.52)',
            },
            dartStyle: dartStyle,
            style: style,
          ),
          children: [
            FlintElement(
              'section',
              props: {
                'style': {
                  'width': '100%',
                  'max-width': _modalWidth(size),
                  'border-radius': '8px',
                  'background': '#ffffff',
                  'box-shadow': '0 20px 40px rgba(16, 24, 40, 0.18)',
                  'overflow': 'hidden',
                },
              },
              children: [
                if (title != null || onClose != null)
                  FlintElement(
                    'header',
                    props: const {
                      'style': {
                        'display': 'flex',
                        'align-items': 'center',
                        'justify-content': 'space-between',
                        'gap': '12px',
                        'padding': '16px',
                        'border-bottom': '1px solid #e4e7ec',
                      },
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
                    'style': {'padding': '16px'}
                  },
                  children: normalizeChildren(child, children),
                ),
                if (actions != null)
                  FlintElement(
                    'footer',
                    props: const {
                      'style': {
                        'display': 'flex',
                        'justify-content': 'flex-end',
                        'gap': '8px',
                        'padding': '16px',
                        'border-top': '1px solid #e4e7ec',
                      },
                    },
                    children: [toFlintNode(actions)],
                  ),
              ],
            ),
          ],
        );
}

String _modalWidth(String size) {
  return switch (size) {
    'sm' => '360px',
    'lg' => '720px',
    'xl' => '960px',
    _ => '520px',
  };
}
