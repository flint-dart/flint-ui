import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// Represents the Form API in Flint UI.
class Form extends FlintElement {
  /// Creates a Form instance.
  Form({
    Object? child,
    List<Object?> children = const [],
    String? method,
    String? action,
    bool disabled = false,
    bool loading = false,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
    void Function(Object event)? onSubmit,
  }) : super(
         'form',
         props: mergeComponentProps(
           {
             ...props,
             if (method != null) 'method': method,
             if (action != null) 'action': action,
             if (disabled) 'aria-disabled': 'true',
             if (loading) 'aria-busy': 'true',
             if (onSubmit != null) 'onSubmit': onSubmit,
           },
           className: className,
           defaultStyle: const {'display': 'grid', 'gap': '16px'},
           dartStyle: dartStyle,
           style: style,
         ),
         children: normalizeChildren(child, children),
       );
}
