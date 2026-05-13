import 'package:universal_web/web.dart' as web;

import 'component.dart';
import 'node.dart';

class HeadTag {
  final String tag;
  final Map<String, Object?> props;
  final String? content;

  const HeadTag(
    this.tag, {
    this.props = const {},
    this.content,
  });

  String get key {
    final id = props['id'];
    if (id != null) return '$tag:id:$id';

    final name = props['name'];
    if (name != null) return '$tag:name:$name';

    final rel = props['rel'];
    final href = props['href'];
    if (rel != null && href != null) return '$tag:rel:$rel:href:$href';

    final src = props['src'];
    if (src != null) return '$tag:src:$src';

    return '$tag:${props.entries.map((entry) => '${entry.key}=${entry.value}').join(';')}:$content';
  }
}

class Head extends FlintComponent {
  final List<HeadTag> tags;
  final String? title;

  Head({
    this.title,
    this.tags = const [],
  });

  Head.withTags(
    List<HeadTag> tags, {
    String? title,
  }) : this(title: title, tags: tags);

  static HeadTag meta({
    String? charset,
    String? name,
    String? content,
    String? property,
    Map<String, Object?> props = const {},
  }) {
    return HeadTag('meta', props: {
      ...props,
      if (charset != null) 'charset': charset,
      if (name != null) 'name': name,
      if (content != null) 'content': content,
      if (property != null) 'property': property,
    });
  }

  static HeadTag link({
    required String href,
    String rel = 'stylesheet',
    Map<String, Object?> props = const {},
  }) {
    return HeadTag('link', props: {
      ...props,
      'rel': rel,
      'href': href,
    });
  }

  static HeadTag script({
    String? src,
    String? content,
    bool defer = false,
    bool async = false,
    Map<String, Object?> props = const {},
  }) {
    return HeadTag('script',
        props: {
          ...props,
          if (src != null) 'src': src,
          if (defer) 'defer': true,
          if (async) 'async': true,
        },
        content: content);
  }

  static HeadTag style(
    String content, {
    Map<String, Object?> props = const {},
  }) {
    return HeadTag('style', props: props, content: content);
  }

  @override
  FlintNode build() => const FlintFragment([]);

  @override
  void didMount() {
    _sync();
  }

  @override
  void didUpdate() {
    _sync();
  }

  void _sync() {
    if (title != null) web.document.title = title!;

    final head = web.document.querySelector('head');
    if (head == null) return;

    for (final tag in tags) {
      final key = tag.key.hashCode.toString();
      final selector = '[data-flint-head="$key"]';
      if (head.querySelector(selector) != null) continue;

      final element = web.document.createElement(tag.tag);
      element.setAttribute('data-flint-head', key);
      _applyProps(element, tag.props);

      if (tag.content != null) {
        element.textContent = tag.content;
      }

      head.appendChild(element);
    }
  }

  void _applyProps(web.Element element, Map<String, Object?> props) {
    props.forEach((name, value) {
      if (value == null || value == false) return;
      if (value == true) {
        element.setAttribute(name, '');
        return;
      }
      element.setAttribute(name, value.toString());
    });
  }
}
