import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';
import '../shared/theme.dart';
import 'controllers.dart';
import 'field_helpers.dart';
import 'package:universal_web/web.dart' as web;

class TextField extends FlintElement {
  TextField({
    String? label,
    String? name,
    TextEditingController? controller,
    Object? value,
    String? placeholder,
    String type = 'text',
    bool required = false,
    bool disabled = false,
    InputVariant variant = InputVariant.outline,
    ComponentSize size = ComponentSize.md,
    String? error,
    String? helpText,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> inputProps = const {},
    Map<String, Object?> style = const {},
    Map<String, Object?> inputStyle = const {},
    DartStyle? dartStyle,
    DartStyle? inputDartStyle,
    void Function(Object event)? onChanged,
  }) : super(
          'div',
          props: fieldWrapperProps(
            props: props,
            className: className,
            dartStyle: dartStyle,
            style: style,
          ),
          children: _children(
            label: label,
            name: name,
            value: controller?.text ?? value,
            placeholder: placeholder,
            type: type,
            required: required,
            disabled: disabled,
            variant: variant,
            size: size,
            error: error,
            helpText: helpText,
            inputProps: inputProps,
            inputStyle: inputStyle,
            inputDartStyle: inputDartStyle,
            onChanged: _controlledOnChanged(controller, onChanged),
          ),
        );

  static void Function(Object event)? _controlledOnChanged(
    TextEditingController? controller,
    void Function(Object event)? onChanged,
  ) {
    if (controller == null) return onChanged;

    return (event) {
      final target = event is web.Event ? event.target : null;
      if (target is web.HTMLInputElement) {
        controller.text = target.value;
      }
      onChanged?.call(event);
    };
  }

  static List<FlintNode> _children({
    required String? label,
    required String? name,
    required Object? value,
    required String? placeholder,
    required String type,
    required bool required,
    required bool disabled,
    required InputVariant variant,
    required ComponentSize size,
    required String? error,
    required String? helpText,
    required Map<String, Object?> inputProps,
    required Map<String, Object?> inputStyle,
    required DartStyle? inputDartStyle,
    required void Function(Object event)? onChanged,
  }) {
    final id = fieldId('field', name, inputProps);
    final ariaDescribedBy = describedBy(
      id: id,
      helpText: helpText,
      error: error,
      describedBy: inputProps['aria-describedby']?.toString(),
    );

    return [
      if (label != null) fieldLabel(id: id, label: label, required: required),
      FlintElement(
        'input',
        props: mergeComponentProps(
          {
            ...controlProps(
              props: inputProps,
              id: id,
              name: name,
              required: required,
              disabled: disabled,
              error: error,
              describedBy: ariaDescribedBy,
            ),
            'type': type,
            if (value != null) 'value': value,
            if (placeholder != null) 'placeholder': placeholder,
            if (onChanged != null) 'onInput': onChanged,
          },
          dartStyle: inputComponentStyle(
            variant: variant,
            size: size,
            disabled: disabled,
            invalid: error != null && error.isNotEmpty,
          ).merge(inputDartStyle),
          style: inputStyle,
        ),
      ),
      ...fieldMessages(id: id, helpText: helpText, error: error),
    ];
  }
}
