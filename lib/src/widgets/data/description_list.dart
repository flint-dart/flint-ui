import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

class DescriptionItem {
  final String label;
  final Object value;

  const DescriptionItem({
    required this.label,
    required this.value,
  });
}

class DescriptionList extends FlintElement {
  DescriptionList({
    List<DescriptionItem> items = const [],
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
          'dl',
          props: mergeComponentProps(
            props,
            className: className,
            defaultStyle: const {
              'display': 'grid',
              'grid-template-columns': 'max-content minmax(0, 1fr)',
              'gap': '10px 16px',
              'margin': 0,
            },
            dartStyle: dartStyle,
            style: style,
          ),
          children: [
            for (final item in items) ...[
              FlintElement(
                'dt',
                props: const {
                  'style': {
                    'color': '#667085',
                    'font-weight': 600,
                  },
                },
                children: normalizeChildren(item.label, const []),
              ),
              FlintElement(
                'dd',
                props: const {
                  'style': {
                    'margin': 0,
                    'color': '#101828',
                  },
                },
                children: normalizeChildren(item.value, const []),
              ),
            ],
          ],
        );
}
