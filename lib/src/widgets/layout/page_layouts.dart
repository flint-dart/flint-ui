import '../../component_props.dart';
import '../../node.dart';
import '../../style.dart';
import 'app_shell.dart';
import 'box.dart';
import 'constrained_box.dart';
import 'page_shell.dart';
import 'responsive_grid.dart';
import 'safe_area.dart';
import 'topbar.dart';

/// Represents the PortfolioShell API in Flint UI.
class PortfolioShell extends FlintElement {
  /// Creates a PortfolioShell instance.
  PortfolioShell({
    Object? nav,
    Object? hero,
    Object? child,
    List<Object?> children = const [],
    Object? footer,
    Object maxWidth = 1120,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         'div',
         props: mergeComponentProps(
           props,
           className: className,
           dartStyle: DartStyle(
             minHeight: '100vh',
             background: ThemeToken.color(
               'pageBackground',
               fallback: '#0b1020',
             ).toCss(),
             color: ThemeToken.color('pageText', fallback: '#f8fafc').toCss(),
           ).merge(dartStyle),
           style: style,
         ),
         children: [
           if (nav != null) toFlintNode(nav),
           ConstrainedBox(
             maxWidth: maxWidth,
             center: true,
             dartStyle: const DartStyle(
               display: Display.grid,
               gap: 56,
               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
             ),
             children: [
               if (hero != null) hero,
               FlintElement(
                 'main',
                 children: normalizeChildren(child, children),
               ),
               if (footer != null) footer,
             ],
           ),
         ],
       );
}

/// Represents the DashboardShell API in Flint UI.
class DashboardShell extends FlintElement {
  /// Creates a DashboardShell instance.
  DashboardShell({
    Object? brand,
    Object? sidebar,
    String? title,
    String? subtitle,
    Object? topbar,
    Object? actions,
    Object? user,
    Object? child,
    List<Object?> children = const [],
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         'div',
         props: mergeComponentProps(
           props,
           className: className,
           dartStyle: dartStyle,
           style: style,
         ),
         children: [
           AppShell(
             brand: brand,
             sidebar: sidebar,
             topbar:
                 topbar ??
                 Topbar(
                   title: title,
                   subtitle: subtitle,
                   actions: actions,
                   user: user,
                 ),
             children: normalizeChildren(child, children),
             dartStyle: DartStyle(
               background: ThemeToken.color(
                 'dashboardBackground',
                 fallback: '#f8fafc',
               ).toCss(),
               color: ThemeToken.color(
                 'dashboardText',
                 fallback: '#101828',
               ).toCss(),
             ),
           ),
         ],
       );
}

/// Represents the AuthShell API in Flint UI.
class AuthShell extends FlintElement {
  /// Creates a AuthShell instance.
  AuthShell({
    Object? brand,
    String? title,
    String? description,
    Object? child,
    List<Object?> children = const [],
    Object? footer,
    Object maxWidth = 420,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
    DartStyle? cardDartStyle,
  }) : super(
         'div',
         props: mergeComponentProps(
           props,
           className: className,
           dartStyle: DartStyle(
             minHeight: '100vh',
             display: Display.grid,
             alignItems: AlignItems.center,
             background: ThemeToken.color(
               'authBackground',
               fallback: '#f8fafc',
             ).toCss(),
             padding: const EdgeInsets.all(24),
           ).merge(dartStyle),
           style: style,
         ),
         children: [
           SafeArea(
             child: ConstrainedBox(
               maxWidth: maxWidth,
               center: true,
               child: Box(
                 tag: 'main',
                 dartStyle: DartStyle(
                   display: Display.grid,
                   gap: 20,
                   padding: const EdgeInsets.all(24),
                   radius: ThemeToken.radius('lg', fallback: '12px').toCss(),
                   background: ThemeToken.color(
                     'surface',
                     fallback: '#ffffff',
                   ).toCss(),
                   border: Border.all(
                     color: ThemeToken.color(
                       'surfaceBorder',
                       fallback: '#e4e7ec',
                     ).toCss(),
                   ),
                   shadow: Shadow(
                     y: 18,
                     blur: 44,
                     spread: -18,
                     color: ThemeToken.shadow(
                       'authCard',
                       fallback: 'rgba(16, 24, 40, 0.22)',
                     ).toCss(),
                   ),
                 ).merge(cardDartStyle),
                 children: [
                   if (brand != null) brand,
                   if (title != null || description != null)
                     _ShellHeading(
                       title: title,
                       description: description,
                       centered: true,
                     ),
                   ...normalizeChildren(child, children),
                   if (footer != null) footer,
                 ],
               ),
             ),
           ),
         ],
       );
}

/// Represents the DocsShell API in Flint UI.
class DocsShell extends FlintElement {
  /// Creates a DocsShell instance.
  DocsShell({
    Object? nav,
    Object? sidebar,
    String? title,
    String? description,
    Object? child,
    List<Object?> children = const [],
    Object? footer,
    Object maxWidth = 1180,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         'div',
         props: mergeComponentProps(
           props,
           className: className,
           dartStyle: DartStyle(
             minHeight: '100vh',
             background: ThemeToken.color(
               'docsBackground',
               fallback: '#ffffff',
             ).toCss(),
             color: ThemeToken.color('docsText', fallback: '#101828').toCss(),
           ).merge(dartStyle),
           style: style,
         ),
         children: [
           if (nav != null) toFlintNode(nav),
           SafeArea(
             child: ConstrainedBox(
               maxWidth: maxWidth,
               center: true,
               child: ResponsiveGrid(
                 columns: sidebar == null
                     ? 'minmax(0, 1fr)'
                     : '260px minmax(0, 1fr)',
                 gap: 32,
                 dartStyle: const DartStyle(
                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                   alignItems: AlignItems.start,
                 ),
                 children: [
                   if (sidebar != null)
                     FlintElement(
                       'aside',
                       children: normalizeChildren(sidebar, const []),
                     ),
                   FlintElement(
                     'main',
                     children: [
                       if (title != null || description != null)
                         _ShellHeading(title: title, description: description),
                       ...normalizeChildren(child, children),
                       if (footer != null) toFlintNode(footer),
                     ],
                   ),
                 ],
               ),
             ),
           ),
         ],
       );
}

/// Represents the MarketingShell API in Flint UI.
class MarketingShell extends FlintElement {
  /// Creates a MarketingShell instance.
  MarketingShell({
    Object? nav,
    Object? hero,
    Object? child,
    List<Object?> children = const [],
    Object? footer,
    Object maxWidth = 1180,
    String? className,
    Map<String, Object?> props = const {},
    Map<String, Object?> style = const {},
    DartStyle? dartStyle,
  }) : super(
         'div',
         props: mergeComponentProps(
           props,
           className: className,
           dartStyle: DartStyle(
             minHeight: '100vh',
             background: ThemeToken.color(
               'marketingBackground',
               fallback: '#ffffff',
             ).toCss(),
             color: ThemeToken.color(
               'marketingText',
               fallback: '#101828',
             ).toCss(),
           ).merge(dartStyle),
           style: style,
         ),
         children: [
           PageShell(
             nav: nav,
             header: hero,
             footer: footer,
             maxWidth: maxWidth,
             padding: 24,
             contentDartStyle: const DartStyle(gap: 40),
             children: normalizeChildren(child, children),
           ),
         ],
       );
}

class _ShellHeading extends FlintElement {
  _ShellHeading({String? title, String? description, bool centered = false})
    : super(
        'header',
        props: mergeComponentProps(
          const {},
          dartStyle: DartStyle(
            display: Display.grid,
            gap: 6,
            margin: const EdgeInsets.only(bottom: 12),
            textAlign: centered ? TextAlign.center : null,
          ),
        ),
        children: [
          if (title != null)
            FlintElement(
              'h1',
              props: const {
                'style': {
                  'margin': 0,
                  'font-size': '28px',
                  'line-height': 1.15,
                },
              },
              children: normalizeChildren(title, const []),
            ),
          if (description != null)
            FlintElement(
              'p',
              props: const {
                'style': {'margin': 0, 'color': '#667085', 'line-height': 1.6},
              },
              children: normalizeChildren(description, const []),
            ),
        ],
      );
}
