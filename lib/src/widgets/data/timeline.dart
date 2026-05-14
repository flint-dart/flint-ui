import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';
import '../shared/theme.dart';

/// Represents the TimelineItem API in Flint UI.
class TimelineItem {
  /// The title value.
  final String title;

  /// The description value.
  final String? description;

  /// The time value.
  final String? time;

  /// The tone value.
  final Tone tone;

  /// Creates a TimelineItem instance.
  const TimelineItem({
    required this.title,
    this.description,
    this.time,
    this.tone = Tone.neutral,
  });
}

/// Represents the Timeline API in Flint UI.
class Timeline extends FlintElement {
  /// Creates a Timeline instance.
  Timeline({
    List<TimelineItem> items = const [],
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         'ol',
         props: mergeComponentProps(
           props,
           className: className,
           defaultStyle: const {
             'display': 'grid',
             'gap': '14px',
             'list-style': 'none',
             'margin': 0,
             'padding': 0,
           },
           dartStyle: dartStyle,
           style: style,
         ),
         children: [
           for (final item in items)
             FlintElement(
               'li',
               props: const {
                 'style': {
                   'display': 'grid',
                   'grid-template-columns': '12px minmax(0, 1fr)',
                   'gap': '10px',
                 },
               },
               children: [
                 FlintElement(
                   'span',
                   props: {
                     'style': {
                       'width': '10px',
                       'height': '10px',
                       'border-radius': '999px',
                       'margin-top': '5px',
                       'background': toneSolid(item.tone),
                     },
                   },
                 ),
                 FlintElement(
                   'div',
                   children: [
                     FlintElement(
                       'strong',
                       children: normalizeChildren(item.title, const []),
                     ),
                     if (item.description != null)
                       FlintElement(
                         'p',
                         props: const {
                           'style': {'margin': 0, 'color': '#667085'},
                         },
                         children: normalizeChildren(
                           item.description,
                           const [],
                         ),
                       ),
                     if (item.time != null)
                       FlintElement(
                         'time',
                         props: const {
                           'style': {'font-size': '12px', 'color': '#98a2b3'},
                         },
                         children: normalizeChildren(item.time, const []),
                       ),
                   ],
                 ),
               ],
             ),
         ],
       );
}
