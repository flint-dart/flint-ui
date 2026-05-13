import 'package:flint_ui/flint_ui_core.dart';
import 'package:test/test.dart';

void main() {
  group('layout components', () {
    test('AppShell renders sidebar, topbar, and main content slots', () {
      final shell = AppShell(
        brand: 'EuPanel',
        sidebar: Sidebar(
          activePath: '/users',
          items: const [
            SidebarItem(label: 'Dashboard', href: '/'),
            SidebarItem(label: 'Users', href: '/users'),
          ],
        ),
        topbar: Topbar(title: 'Users', actions: Button(child: 'Create')),
        child: Text('Main content'),
      );

      expect(shell.tag, 'div');
      expect(shell.props['style'], containsPair('display', 'grid'));
      expect(shell.children.first, isA<FlintElement>());
      expect(shell.children.last, isA<FlintElement>());

      final aside = shell.children.first as FlintElement;
      expect(aside.tag, 'aside');
      expect(aside.children.first, isA<FlintElement>());
      expect(aside.children.last, isA<Sidebar>());

      final content = shell.children.last as FlintElement;
      final main = content.children.last as FlintElement;
      expect(main.tag, 'main');
      expect(main.children.single, isA<Text>());
    });

    test('Sidebar marks active item and supports collapsed labels', () {
      final sidebar = Sidebar(
        activePath: '/users',
        collapsed: true,
        items: const [
          SidebarItem(label: 'Dashboard', href: '/'),
          SidebarItem(label: 'Users', href: '/users', icon: 'U'),
        ],
      );

      final active = sidebar.children.last as FlintElement;
      expect(active.props['aria-current'], 'page');
      expect(active.children, hasLength(1));
      expect(active.children.single, isA<FlintText>());
    });

    test('Sidebar supports item style and class customization', () {
      final sidebar = Sidebar(
        activePath: '/users',
        itemClassName: 'nav-item',
        activeItemClassName: 'nav-item-active',
        itemStyle: {'border-radius': '12px'},
        activeItemStyle: {'background': '#000'},
        itemDartStyle: const DartStyle(gap: 14),
        items: const [
          SidebarItem(label: 'Users', href: '/users', className: 'custom-user'),
        ],
      );

      final item = sidebar.children.single as FlintElement;
      expect(item.props['className'], 'nav-item nav-item-active custom-user');
      expect(item.props['style'], containsPair('background', '#000'));
      expect(item.props['style'], containsPair('border-radius', '12px'));
      expect(item.props['style'], containsPair('gap', '14px'));
    });

    test('Topbar and PageHeader render titles and actions', () {
      final topbar = Topbar(
        title: 'Dashboard',
        subtitle: 'Overview',
        actions: Button(child: 'Refresh'),
      );
      expect(topbar.tag, 'header');
      expect(topbar.children, hasLength(2));

      final header = PageHeader(
        title: 'Subscriptions',
        description: 'Manage billing and renewal state.',
        actions: Button(child: 'New'),
      );
      expect(header.tag, 'header');
      expect(header.children.last, isA<Button>());
    });

    test('Section, Panel, StatCard, and EmptyState render expected surfaces',
        () {
      final section = Section(
        title: 'Recent jobs',
        description: 'Provisioning activity',
        child: Text('Jobs list'),
      );
      expect(section.tag, 'section');
      expect(section.children, hasLength(2));

      final panel = Panel(title: 'Plan', child: Text('Starter'));
      expect(panel.tag, 'section');
      expect(panel.props['style'], containsPair('border-radius', '8px'));

      final stat = StatCard(
        label: 'Active users',
        value: 42,
        trend: '+12%',
        tone: Tone.success,
        variant: CardVariant.elevated,
      );
      expect(stat.tag, 'article');
      expect(
        stat.props['style'],
        containsPair(
          'box-shadow',
          '0px 8px 24px -8px var(--shadow-card, rgba(16, 24, 40, 0.18))',
        ),
      );
      expect(stat.children.last, isA<StatusBadge>());

      final empty = EmptyState(
        title: 'No domains',
        message: 'Connect a domain to continue.',
        action: Button(child: 'Add domain'),
      );
      expect(empty.tag, 'div');
      expect(empty.children.last, isA<Button>());
    });

    test('layout primitives render grid, wrap, stack, spacer, and divider', () {
      final grid = Grid(
        columns: 'repeat(3, minmax(0, 1fr))',
        gap: 16,
        children: [Text('A'), Text('B')],
      );
      expect(grid.props['style'], containsPair('display', 'grid'));
      expect(
        grid.props['style'],
        containsPair('grid-template-columns', 'repeat(3, minmax(0, 1fr))'),
      );
      expect(grid.props['style'], containsPair('gap', '16px'));

      final wrap = Wrap(gap: 8, children: [Text('A'), Text('B')]);
      expect(wrap.props['style'], containsPair('display', 'flex'));
      expect(wrap.props['style'], containsPair('flex-wrap', 'wrap'));

      final stack = Stack(children: [Text('Base')]);
      expect(stack.props['style'], containsPair('position', 'relative'));

      final spacer = Spacer(flex: 2);
      expect(spacer.props['style'], containsPair('flex', 2));

      final divider = Divider(vertical: true, thickness: 2);
      expect(divider.props['role'], 'separator');
      expect(divider.props['aria-orientation'], 'vertical');
      expect(divider.props['style'], containsPair('width', '2px'));
    });

    test('box, center, safe area, and constraints render typed layout styles',
        () {
      final box = Box(
        tag: 'section',
        padding: 16,
        radius: 12,
        background: '#fff',
        child: Text('Surface'),
      );
      expect(box.tag, 'section');
      expect(box.props['style'], containsPair('padding', '16px'));
      expect(box.props['style'], containsPair('border-radius', '12px'));

      final center = Center(inline: true, child: Text('Centered'));
      expect(center.props['style'], containsPair('display', 'inline-flex'));
      expect(center.props['style'], containsPair('align-items', 'center'));
      expect(center.props['style'], containsPair('justify-content', 'center'));

      final safe = SafeArea(minimum: 12, child: Text('Safe'));
      expect(
        safe.props['style'],
        containsPair(
          'padding',
          'max(env(safe-area-inset-top), 12px) max(env(safe-area-inset-right), 12px) max(env(safe-area-inset-bottom), 12px) max(env(safe-area-inset-left), 12px)',
        ),
      );

      final constrained = ConstrainedBox(
        maxWidth: 960,
        center: true,
        child: Text('Content'),
      );
      expect(constrained.props['style'], containsPair('width', '100%'));
      expect(constrained.props['style'], containsPair('max-width', '960px'));
      expect(constrained.props['style'], containsPair('margin', '0px auto'));
    });

    test('responsive grid and aspect ratio box use scoped Dart styles', () {
      final responsive = ResponsiveGrid(
        minItemWidth: 220,
        gap: 20,
        md: 'repeat(2, minmax(0, 1fr))',
        lg: 'repeat(4, minmax(0, 1fr))',
        children: [Text('A'), Text('B')],
      );
      expect(responsive.props['className'], contains('flint-s-'));
      expect(responsive.props['style'], containsPair('display', 'grid'));
      expect(
        responsive.props['style'],
        containsPair(
          'grid-template-columns',
          'repeat(auto-fit, minmax(220px, 1fr))',
        ),
      );
      expect(responsive.props['_flintStyleCss'], contains('@media'));
      expect(
        responsive.props['_flintStyleCss'],
        contains('repeat(4, minmax(0, 1fr))'),
      );

      final ratio = AspectRatioBox.video(
        overflow: Overflow.hidden,
        child: Text('Preview'),
      );
      expect(ratio.props['style'], containsPair('aspect-ratio', '16 / 9'));
      expect(ratio.props['style'], containsPair('overflow', 'hidden'));
    });

    test('PageShell composes nav, safe content, main, and footer slots', () {
      final shell = PageShell(
        nav: Text('Nav'),
        header: Text('Header'),
        footer: Text('Footer'),
        child: Text('Body'),
        maxWidth: 1080,
      );

      expect(shell.tag, 'div');
      expect(shell.props['style'], containsPair('min-height', '100vh'));
      expect(shell.children.first, isA<Text>());
      final safe = shell.children.last as SafeArea;
      final constrained = safe.children.single as ConstrainedBox;
      expect(constrained.props['style'], containsPair('max-width', '1080px'));
      final main = constrained.children[1] as FlintElement;
      expect(main.tag, 'main');
      expect(main.children.single, isA<Text>());
    });
  });
}
