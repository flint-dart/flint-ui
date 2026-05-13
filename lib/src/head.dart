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

    final property = props['property'];
    if (property != null) return '$tag:property:$property';

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
  final String? description;
  final String? canonical;
  final String? image;
  final String? type;
  final String? siteName;
  final String? locale;
  final bool replace;

  Head({
    this.title,
    this.description,
    this.canonical,
    this.image,
    this.type,
    this.siteName,
    this.locale,
    this.replace = true,
    this.tags = const [],
  });

  Head.withTags(
    List<HeadTag> tags, {
    String? title,
  }) : this(title: title, tags: tags);

  Head.seo({
    String? title,
    String? description,
    String? canonical,
    String? image,
    String? type = 'website',
    String? siteName,
    String? locale,
    List<HeadTag> tags = const [],
  }) : this(
          title: title,
          description: description,
          canonical: canonical,
          image: image,
          type: type,
          siteName: siteName,
          locale: locale,
          tags: tags,
        );

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

    for (final tag in _resolvedTags()) {
      final key = tag.key;
      final element =
          _findExisting(head, tag, key) ?? web.document.createElement(tag.tag);

      element.setAttribute('data-flint-head', key);
      _syncProps(element, tag.props);
      if (tag.content != null) element.textContent = tag.content;
      if (element.parentElement == null) head.appendChild(element);
    }
  }

  List<HeadTag> _resolvedTags() {
    return [
      if (description != null)
        Head.meta(name: 'description', content: description),
      if (title != null) Head.meta(property: 'og:title', content: title),
      if (description != null)
        Head.meta(property: 'og:description', content: description),
      if (canonical != null) Head.link(rel: 'canonical', href: canonical!),
      if (canonical != null) Head.meta(property: 'og:url', content: canonical),
      if (image != null) Head.meta(property: 'og:image', content: image),
      if (type != null) Head.meta(property: 'og:type', content: type),
      if (siteName != null)
        Head.meta(property: 'og:site_name', content: siteName),
      if (locale != null) Head.meta(property: 'og:locale', content: locale),
      ...tags,
    ];
  }

  web.Element? _findExisting(web.Element head, HeadTag tag, String key) {
    final tracked = head.querySelector('[data-flint-head="$key"]');
    if (tracked != null) return tracked;
    if (!replace) return null;

    if (tag.props['id'] case final id?) {
      return head.querySelector('${tag.tag}#${_cssEscape(id.toString())}');
    }
    if (tag.props['name'] case final name?) {
      return head.querySelector('${tag.tag}[name="${_attrEscape(name)}"]');
    }
    if (tag.props['property'] case final property?) {
      return head
          .querySelector('${tag.tag}[property="${_attrEscape(property)}"]');
    }
    if (tag.props['rel'] case final rel?) {
      return head.querySelector('${tag.tag}[rel="${_attrEscape(rel)}"]');
    }
    return null;
  }

  void _syncProps(web.Element element, Map<String, Object?> props) {
    final next = {
      'data-flint-head': element.getAttribute('data-flint-head'),
      for (final entry in props.entries)
        if (entry.value != null && entry.value != false) entry.key: entry.value,
    };

    final attributeNames = <String>[];
    final attributes = element.attributes;
    for (var i = 0; i < attributes.length; i++) {
      final attribute = attributes.item(i);
      if (attribute != null) attributeNames.add(attribute.name);
    }

    for (final name in attributeNames) {
      if (!next.containsKey(name)) element.removeAttribute(name);
    }

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

String _attrEscape(Object value) {
  return value.toString().replaceAll(r'\', r'\\').replaceAll('"', r'\"');
}

String _cssEscape(String value) {
  return value.replaceAll(RegExp(r'([^a-zA-Z0-9_-])'), r'\$1');
}
