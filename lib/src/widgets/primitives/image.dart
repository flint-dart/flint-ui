import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

/// Represents the Image API in Flint UI.
class Image extends FlintElement {
  /// Creates a Image instance.
  Image({
    required String src,
    String alt = '',
    Object? width,
    Object? height,
    String? srcSet,
    String? sizes,
    ImageLoading loading = ImageLoading.lazy,
    ImageDecoding decoding = ImageDecoding.async,
    String? fetchPriority,
    String? referrerPolicy,
    String? crossOrigin,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         'img',
         props: mergeComponentProps(
           {
             ...props,
             'src': src,
             'alt': alt,
             if (width != null) 'width': cssValue(width),
             if (height != null) 'height': cssValue(height),
             if (srcSet != null) 'srcset': srcSet,
             if (sizes != null) 'sizes': sizes,
             'loading': loading.value,
             'decoding': decoding.value,
             if (fetchPriority != null) 'fetchpriority': fetchPriority,
             if (referrerPolicy != null) 'referrerpolicy': referrerPolicy,
             if (crossOrigin != null) 'crossorigin': crossOrigin,
           },
           className: className,
           defaultStyle: const {'display': 'block', 'max-width': '100%'},
           dartStyle: dartStyle,
           style: style,
         ),
       );
}

/// Represents the Figure API in Flint UI.
class Figure extends FlintElement {
  /// Creates a Figure instance.
  Figure({
    required Object image,
    Object? caption,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
    DartStyle? captionStyle,
    Map<String, Object?> captionProps = const {},
  }) : super(
         'figure',
         props: mergeComponentProps(
           props,
           className: className,
           defaultStyle: const {'display': 'grid', 'gap': '8px', 'margin': '0'},
           dartStyle: dartStyle,
           style: style,
         ),
         children: [
           toFlintNode(image),
           if (caption != null)
             FlintElement(
               'figcaption',
               props: mergeComponentProps(
                 captionProps,
                 defaultStyle: const {
                   'color': '#667085',
                   'font-size': '14px',
                   'line-height': '1.5',
                 },
                 dartStyle: captionStyle,
               ),
               children: normalizeChildren(caption, const []),
             ),
         ],
       );
}

/// Options for the ImageLoading API.
enum ImageLoading {
  /// Creates a eager instance.
  eager('eager'),

  /// Creates a lazy instance.
  lazy('lazy');

  /// The value value.
  final String value;

  /// Creates a ImageLoading instance.
  const ImageLoading(this.value);
}

/// Options for the ImageDecoding API.
enum ImageDecoding {
  /// Creates a async instance.
  async('async'),

  /// Creates a auto instance.
  auto('auto'),

  /// Creates a sync instance.
  sync('sync');

  /// The value value.
  final String value;

  /// Creates a ImageDecoding instance.
  const ImageDecoding(this.value);
}
