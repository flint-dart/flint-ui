import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

class Image extends FlintElement {
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
            defaultStyle: const {
              'display': 'block',
              'max-width': '100%',
            },
            dartStyle: dartStyle,
            style: style,
          ),
        );
}

class Figure extends FlintElement {
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
            defaultStyle: const {
              'display': 'grid',
              'gap': '8px',
              'margin': '0',
            },
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

enum ImageLoading {
  eager('eager'),
  lazy('lazy');

  final String value;
  const ImageLoading(this.value);
}

enum ImageDecoding {
  async('async'),
  auto('auto'),
  sync('sync');

  final String value;
  const ImageDecoding(this.value);
}
