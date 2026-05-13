import '../../style.dart';
import 'text_field.dart';
import 'validation.dart';

class FileInput extends TextField {
  FileInput({
    String? label,
    String? name,
    String? accept,
    bool multiple = false,
    bool required = false,
    bool disabled = false,
    String? error,
    FormErrors? errors,
    String? helpText,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> inputProps = const {},
    Map<String, Object?> style = const {},
    Map<String, Object?> inputStyle = const {},
    DartStyle? dartStyle,
    void Function(Object event)? onChanged,
  }) : super(
          label: label,
          name: name,
          type: 'file',
          required: required,
          disabled: disabled,
          error: error,
          errors: errors,
          helpText: helpText,
          className: className,
          props: props,
          inputProps: {
            ...inputProps,
            if (accept != null) 'accept': accept,
            if (multiple) 'multiple': true,
          },
          style: style,
          inputStyle: inputStyle,
          dartStyle: dartStyle,
          onChanged: onChanged,
        );
}
