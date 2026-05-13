import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

class ButtonGroup extends FlintElement {
  ButtonGroup({
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
            defaultStyle: const {
              'display': 'inline-flex',
              'align-items': 'center',
              'gap': '8px',
            },
            dartStyle: dartStyle,
            style: style,
          ),
          children: normalizeChildren(child, children),
        );
}
