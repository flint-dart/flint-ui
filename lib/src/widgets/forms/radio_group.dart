import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';
import 'field_helpers.dart';

class RadioOption {
  final String label;
  final Object value;
  final bool disabled;

  const RadioOption({
    required this.label,
    required this.value,
    this.disabled = false,
  });
}

class RadioGroup extends FlintElement {
  RadioGroup({
    String? label,
    String? name,
    Object? value,
    List<RadioOption> options = const [],
    bool required = false,
    bool disabled = false,
    String? error,
    String? helpText,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
    void Function(Object event)? onChanged,
  }) : super(
          'fieldset',
          props: mergeComponentProps(
            {
              ...props,
              if (disabled) 'disabled': true,
              if (error != null && error.isNotEmpty) 'aria-invalid': 'true',
            },
            className: className,
            defaultStyle: fieldWrapperStyle,
            dartStyle: dartStyle,
            style: style,
          ),
          children: _children(
            label: label,
            name: name,
            value: value,
            options: options,
            required: required,
            disabled: disabled,
            error: error,
            helpText: helpText,
            onChanged: onChanged,
          ),
        );

  static List<FlintNode> _children({
    required String? label,
    required String? name,
    required Object? value,
    required List<RadioOption> options,
    required bool required,
    required bool disabled,
    required String? error,
    required String? helpText,
    required void Function(Object event)? onChanged,
  }) {
    final groupId = fieldId('radio', name, const {});

    return [
      if (label != null)
        FlintElement(
          'legend',
          props: {'style': fieldLabelStyle},
          children: normalizeChildren(required ? '$label *' : label, const []),
        ),
      FlintElement(
        'div',
        props: const {
          'style': {
            'display': 'grid',
            'gap': '8px',
          },
        },
        children: [
          for (var i = 0; i < options.length; i++)
            _radioOption(
              id: '$groupId-$i',
              name: name,
              option: options[i],
              selectedValue: value,
              required: required,
              disabled: disabled || options[i].disabled,
              onChanged: onChanged,
            ),
        ],
      ),
      ...fieldMessages(id: groupId, helpText: helpText, error: error),
    ];
  }

  static FlintElement _radioOption({
    required String id,
    required String? name,
    required RadioOption option,
    required Object? selectedValue,
    required bool required,
    required bool disabled,
    required void Function(Object event)? onChanged,
  }) {
    return FlintElement(
      'label',
      props: {'for': id, 'style': choiceRowStyle},
      children: [
        FlintElement(
          'input',
          props: {
            'id': id,
            if (name != null) 'name': name,
            'type': 'radio',
            'value': option.value,
            if (selectedValue == option.value) 'checked': true,
            if (required) 'required': true,
            if (disabled) 'disabled': true,
            if (onChanged != null) 'onChange': onChanged,
          },
        ),
        FlintText(option.label),
      ],
    );
  }
}
