import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';

class SidebarItem {
  final String label;
  final String href;
  final Object? icon;
  final bool active;
  final bool disabled;
  final String? className;
  final Map<String, Object?> props;
  final Map<String, Object?> style;
  final DartStyle? dartStyle;

  const SidebarItem({
    required this.label,
    required this.href,
    this.icon,
    this.active = false,
    this.disabled = false,
    this.className,
    this.props = const {},
    this.style = const {},
    this.dartStyle,
  });
}

class Sidebar extends FlintElement {
  Sidebar({
    List<SidebarItem> items = const [],
    String? activePath,
    bool collapsed = false,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
    String? itemClassName,
    String? activeItemClassName,
    Map<String, Object?> itemStyle = const {},
    Map<String, Object?> activeItemStyle = const {},
    DartStyle? itemDartStyle,
    DartStyle? activeItemDartStyle,
    void Function(Object event)? onToggle,
  }) : super(
          'nav',
          props: mergeComponentProps(
            {
              ...props,
              'aria-label': props['aria-label'] ?? 'Sidebar',
            },
            className: className,
            defaultStyle: const {
              'display': 'grid',
              'gap': '6px',
              'padding': '12px',
            },
            dartStyle: dartStyle,
            style: style,
          ),
          children: [
            if (onToggle != null)
              FlintElement(
                'button',
                props: {
                  'type': 'button',
                  'aria-expanded': (!collapsed).toString(),
                  'onClick': onToggle,
                },
                children: normalizeChildren(
                    collapsed ? 'Expand' : 'Collapse', const []),
              ),
            for (final item in items)
              _sidebarLink(
                item,
                active: item.active || item.href == activePath,
                collapsed: collapsed,
                itemClassName: itemClassName,
                activeItemClassName: activeItemClassName,
                itemStyle: itemStyle,
                activeItemStyle: activeItemStyle,
                itemDartStyle: itemDartStyle,
                activeItemDartStyle: activeItemDartStyle,
              ),
          ],
        );

  static FlintElement _sidebarLink(
    SidebarItem item, {
    required bool active,
    required bool collapsed,
    required String? itemClassName,
    required String? activeItemClassName,
    required Map<String, Object?> itemStyle,
    required Map<String, Object?> activeItemStyle,
    required DartStyle? itemDartStyle,
    required DartStyle? activeItemDartStyle,
  }) {
    return FlintElement(
      'a',
      props: mergeComponentProps(
        {
          ...item.props,
          'href': item.disabled ? '#' : item.href,
          if (active) 'aria-current': 'page',
          if (item.disabled) 'aria-disabled': 'true',
        },
        className: joinClassNames([
          itemClassName,
          if (active) activeItemClassName,
          item.className,
        ]),
        defaultStyle: {
          'display': 'flex',
          'align-items': 'center',
          'gap': '10px',
          'min-height': '38px',
          'border-radius': '8px',
          'padding': collapsed ? '0 10px' : '0 12px',
          'text-decoration': 'none',
          'color': active ? '#1849a9' : '#344054',
          'background': active ? '#eff4ff' : 'transparent',
          'font-weight': active ? 700 : 500,
        },
        variantStyle: active ? activeItemStyle : const {},
        dartStyle:
            active ? activeItemDartStyle ?? itemDartStyle : itemDartStyle,
        style: {
          ...itemStyle,
          ...item.style,
        },
      ),
      children: [
        if (item.icon != null) toFlintNode(item.icon),
        if (!collapsed) FlintText(item.label),
      ],
    );
  }
}
