import '../../style.dart';
import 'checkbox.dart';

class Switch extends Checkbox {
  Switch({
    String? label,
    String? name,
    bool checked = false,
    bool disabled = false,
    String? error,
    String? helpText,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> inputProps = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
    void Function(Object event)? onChanged,
  }) : super(
          label: label,
          name: name,
          checked: checked,
          disabled: disabled,
          error: error,
          helpText: helpText,
          className: className,
          props: props,
          inputProps: {
            ...inputProps,
            'role': 'switch',
            'aria-checked': checked.toString(),
          },
          style: style,
          dartStyle: dartStyle,
          onChanged: onChanged,
        );
}
