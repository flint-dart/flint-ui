import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';
import '../feedback/spinner.dart';
import '../shared/theme.dart';

/// Represents the Button API in Flint UI.
class Button extends FlintElement {
  /// Creates a Button instance.
  Button({
    Object? child,
    List<Object?> children = const [],
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
    ButtonVariant variant = ButtonVariant.solid,
    Tone tone = Tone.primary,
    ComponentSize size = ComponentSize.md,
    bool loading = false,
    bool disabled = false,
    void Function(Object event)? onPressed,
  }) : super(
         'button',
         props: mergeComponentProps(
           {
             ...props,
             'type': props['type'] ?? 'button',
             if (disabled || loading) 'disabled': true,
             if (loading) 'aria-busy': 'true',
             if (onPressed != null && !disabled && !loading)
               'onClick': onPressed,
           },
           className: className,
           dartStyle: buttonComponentStyle(
             variant: variant,
             tone: tone,
             size: size,
             disabled: disabled,
             loading: loading,
           ).merge(dartStyle),
           style: style,
         ),
         children: [
           if (loading) Spinner(size: ComponentSize.xs, tone: tone),
           ...normalizeChildren(child, children),
         ],
       );
}
