import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// Represents the TableColumn API in Flint UI.
class TableColumn {
  /// The key value.
  final String key;

  /// The label value.
  final String label;

  /// The header value.
  final Object? header;

  /// The align value.
  final String? align;

  /// The className value.
  final String? className;

  /// The headerStyle value.
  final Map<String, Object?> headerStyle;

  /// The cellStyle value.
  final Map<String, Object?> cellStyle;

  /// The headerDartStyle value.
  final DartStyle? headerDartStyle;

  /// The cellDartStyle value.
  final DartStyle? cellDartStyle;

  /// Creates a TableColumn instance.
  const TableColumn({
    required this.key,
    required this.label,
    this.header,
    this.align,
    this.className,
    this.headerStyle = const {},
    this.cellStyle = const {},
    this.headerDartStyle,
    this.cellDartStyle,
  });
}

/// Represents the TableRowData API in Flint UI.
class TableRowData {
  /// The key value.
  final String? key;

  /// The cells value.
  final Map<String, Object?> cells;

  /// The actions value.
  final Object? actions;

  /// The selected value.
  final bool selected;

  /// The className value.
  final String? className;

  /// The props value.
  final Map<String, Object?> props;

  /// The style value.
  final Map<String, Object?> style;

  /// The dartStyle value.
  final DartStyle? dartStyle;

  /// Creates a TableRowData instance.
  const TableRowData({
    this.key,
    required this.cells,
    this.actions,
    this.selected = false,
    this.className,
    this.props = const {},
    this.style = const {},
    this.dartStyle,
  });
}

/// Represents the Table API in Flint UI.
class Table extends FlintElement {
  /// Creates a Table instance.
  Table({
    List<TableColumn> columns = const [],
    List<TableRowData> rows = const [],
    Object? emptyState,
    bool loading = false,
    Object? loadingState,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
    String? tableClassName,
    Map<String, Object?> tableProps = const {},
    Map<String, Object?> tableStyle = const {},
    DartStyle? tableDartStyle,
    String? headerClassName,
    Map<String, Object?> headerStyle = const {},
    DartStyle? headerDartStyle,
    String? rowClassName,
    String? selectedRowClassName,
    Map<String, Object?> rowStyle = const {},
    Map<String, Object?> selectedRowStyle = const {},
    DartStyle? rowDartStyle,
    DartStyle? selectedRowDartStyle,
    String? cellClassName,
    Map<String, Object?> cellStyle = const {},
    DartStyle? cellDartStyle,
    void Function(Object event, TableRowData row)? onRowClick,
  }) : super(
         'div',
         props: mergeComponentProps(
           props,
           className: className,
           defaultStyle: const {
             'overflow-x': 'auto',
             'border': '1px solid #e4e7ec',
             'border-radius': '8px',
             'background': '#ffffff',
           },
           dartStyle: dartStyle,
           style: style,
         ),
         children: [
           if (loading)
             toFlintNode(loadingState ?? 'Loading...')
           else if (rows.isEmpty)
             toFlintNode(emptyState ?? 'No records found.')
           else
             FlintElement(
               'table',
               props: mergeComponentProps(
                 tableProps,
                 className: tableClassName,
                 defaultStyle: const {
                   'width': '100%',
                   'border-collapse': 'collapse',
                 },
                 dartStyle: tableDartStyle,
                 style: tableStyle,
               ),
               children: [
                 _thead(
                   columns,
                   headerClassName: headerClassName,
                   headerStyle: headerStyle,
                   headerDartStyle: headerDartStyle,
                 ),
                 _tbody(
                   columns,
                   rows,
                   onRowClick,
                   rowClassName: rowClassName,
                   selectedRowClassName: selectedRowClassName,
                   rowStyle: rowStyle,
                   selectedRowStyle: selectedRowStyle,
                   rowDartStyle: rowDartStyle,
                   selectedRowDartStyle: selectedRowDartStyle,
                   cellClassName: cellClassName,
                   cellStyle: cellStyle,
                   cellDartStyle: cellDartStyle,
                 ),
               ],
             ),
         ],
       );

  static FlintElement _thead(
    List<TableColumn> columns, {
    required String? headerClassName,
    required Map<String, Object?> headerStyle,
    required DartStyle? headerDartStyle,
  }) {
    return FlintElement(
      'thead',
      children: [
        FlintElement(
          'tr',
          children: [
            for (final column in columns)
              FlintElement(
                'th',
                props: mergeComponentProps(
                  {'scope': 'col'},
                  className: joinClassNames([
                    headerClassName,
                    column.className,
                  ]),
                  defaultStyle: {
                    'padding': '12px',
                    'text-align': column.align ?? 'left',
                    'font-size': '12px',
                    'font-weight': 700,
                    'color': '#475467',
                    'border-bottom': '1px solid #e4e7ec',
                    'background': '#f9fafb',
                  },
                  dartStyle: column.headerDartStyle ?? headerDartStyle,
                  style: {...headerStyle, ...column.headerStyle},
                ),
                children: normalizeChildren(
                  column.header ?? column.label,
                  const [],
                ),
              ),
          ],
        ),
      ],
    );
  }

  static FlintElement _tbody(
    List<TableColumn> columns,
    List<TableRowData> rows,
    void Function(Object event, TableRowData row)? onRowClick, {
    required String? rowClassName,
    required String? selectedRowClassName,
    required Map<String, Object?> rowStyle,
    required Map<String, Object?> selectedRowStyle,
    required DartStyle? rowDartStyle,
    required DartStyle? selectedRowDartStyle,
    required String? cellClassName,
    required Map<String, Object?> cellStyle,
    required DartStyle? cellDartStyle,
  }) {
    return FlintElement(
      'tbody',
      children: [
        for (final row in rows)
          FlintElement(
            'tr',
            props: mergeComponentProps(
              {
                ...row.props,
                if (row.key != null) 'data-row-key': row.key,
                if (row.selected) 'aria-selected': 'true',
                if (onRowClick != null)
                  'onClick': (Object event) => onRowClick(event, row),
              },
              className: joinClassNames([
                rowClassName,
                if (row.selected) selectedRowClassName,
                row.className,
              ]),
              defaultStyle: {
                'cursor': onRowClick == null ? 'default' : 'pointer',
                'background': row.selected ? '#eff4ff' : '#ffffff',
              },
              variantStyle: row.selected ? selectedRowStyle : const {},
              dartStyle: row.selected
                  ? selectedRowDartStyle ?? rowDartStyle
                  : rowDartStyle,
              style: {...rowStyle, ...row.style},
            ),
            children: [
              for (final column in columns)
                FlintElement(
                  'td',
                  props: mergeComponentProps(
                    const {},
                    className: joinClassNames([
                      cellClassName,
                      column.className,
                    ]),
                    defaultStyle: {
                      'padding': '12px',
                      'text-align': column.align ?? 'left',
                      'border-bottom': '1px solid #f2f4f7',
                    },
                    dartStyle: column.cellDartStyle ?? cellDartStyle,
                    style: {...cellStyle, ...column.cellStyle},
                  ),
                  children: normalizeChildren(
                    row.cells[column.key] ?? '',
                    const [],
                  ),
                ),
              if (row.actions != null)
                FlintElement(
                  'td',
                  props: const {
                    'style': {
                      'padding': '12px',
                      'text-align': 'right',
                      'border-bottom': '1px solid #f2f4f7',
                    },
                  },
                  children: [toFlintNode(row.actions)],
                ),
            ],
          ),
      ],
    );
  }
}
