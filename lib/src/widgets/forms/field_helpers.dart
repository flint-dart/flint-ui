import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

String fieldId(String prefix, String? name, Map<String, Object?> props) {
  final explicit = props['id']?.toString();

  /// Creates a if instance.
  if (explicit != null && explicit.isNotEmpty) return explicit;

  /// The name value.
  final base = (name == null || name.isEmpty) ? prefix : name;
  return 'flint-$prefix-${_safeId(base)}';
}

String? describedBy({
  required String id,
  required String? helpText,
  required String? error,
  String? describedBy,
}) {
  final values = [
    if (describedBy != null && describedBy.isNotEmpty) describedBy,
    if (helpText != null && helpText.isNotEmpty) '$id-help',
    if (error != null && error.isNotEmpty) '$id-error',
  ];

  return values.isEmpty ? null : values.join(' ');
}

List<FlintNode> fieldMessages({
  required String id,
  required String? helpText,
  required String? error,
}) {
  return [
    if (helpText != null && helpText.isNotEmpty)
      FlintElement(
        'p',
        props: {'id': '$id-help', 'style': fieldHelpStyle},
        children: normalizeChildren(helpText, const []),
      ),
    if (error != null && error.isNotEmpty)
      FlintElement(
        'p',
        props: {'id': '$id-error', 'style': fieldErrorStyle},
        children: normalizeChildren(error, const []),
      ),
  ];
}

FlintElement fieldLabel({
  required String id,
  required String label,
  bool required = false,
}) {
  return FlintElement(
    'label',
    props: {'for': id, 'style': fieldLabelStyle},
    children: [FlintText(label), if (required) const FlintText(' *')],
  );
}

Map<String, Object?> fieldWrapperProps({
  required Map<String, Object?> props,
  required String? className,
  required DartStyle? dartStyle,
  required Map<String, Object?> style,
}) {
  return mergeComponentProps(
    props,
    className: className,
    defaultStyle: fieldWrapperStyle,
    dartStyle: dartStyle,
    style: style,
  );
}

Map<String, Object?> controlProps({
  required Map<String, Object?> props,
  required String id,
  required String? name,
  required bool required,
  required bool disabled,
  required String? error,
  required String? describedBy,
}) {
  return {
    ...props,
    'id': id,
    if (name != null) 'name': name,
    if (required) 'required': true,
    if (disabled) 'disabled': true,
    if (error != null && error.isNotEmpty) 'aria-invalid': 'true',
    if (describedBy != null) 'aria-describedby': describedBy,
  };
}

const fieldWrapperStyle = {'display': 'grid', 'gap': '6px'};

const fieldLabelStyle = {
  'font-size': '14px',
  'font-weight': 600,
  'color': '#344054',
};

const fieldHelpStyle = {'margin': 0, 'font-size': '13px', 'color': '#667085'};

const fieldErrorStyle = {'margin': 0, 'font-size': '13px', 'color': '#b42318'};

const inputBaseStyle = {
  'width': '100%',
  'min-height': '40px',
  'border': '1px solid #d0d5dd',
  'border-radius': '8px',
  'padding': '8px 10px',
  'font': 'inherit',
  'color': '#101828',
  'background': '#ffffff',
};

const choiceRowStyle = {
  'display': 'inline-flex',
  'align-items': 'center',
  'gap': '8px',
  'font-size': '14px',
  'color': '#344054',
};

String _safeId(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9_-]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}
