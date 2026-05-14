import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';
import '../feedback/spinner.dart';
import '../shared/theme.dart';

/// Represents the IconButton API in Flint UI.
class IconButton extends FlintElement {
  /// Creates a IconButton instance.
  IconButton({
    required Object icon,
    required String label,
    String? tooltip,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
    ButtonVariant variant = ButtonVariant.ghost,
    Tone tone = Tone.neutral,
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
             'aria-label': label,
             if (tooltip != null) 'title': tooltip,
             if (disabled || loading) 'disabled': true,
             if (loading) 'aria-busy': 'true',
             if (onPressed != null && !disabled && !loading)
               'onClick': onPressed,
           },
           className: className,
           dartStyle:
               buttonComponentStyle(
                     variant: variant,
                     tone: tone,
                     size: size,
                     disabled: disabled,
                     loading: loading,
                   )
                   .merge(
                     DartStyle(
                       width: iconButtonSize(size),
                       padding: const EdgeInsets.all(0),
                     ),
                   )
                   .merge(dartStyle),
           style: style,
         ),
         children: [
           if (loading)
             Spinner(size: ComponentSize.xs, tone: tone)
           else
             toFlintNode(icon),
         ],
       );
}
