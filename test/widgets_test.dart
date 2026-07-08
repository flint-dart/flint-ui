import 'package:flint_ui/flint_ui_core.dart';
import 'package:test/test.dart';

void main() {
  group('Button', () {
    test('renders variant, size, tone, and loading state', () {
      final button = Button(
        child: Text('Save'),
        variant: ButtonVariant.solid,
        tone: Tone.success,
        size: ComponentSize.sm,
        loading: true,
        onPressed: (_) {},
      );

      expect(button.props['disabled'], true);
      expect(button.props['aria-busy'], 'true');
      expect(button.props.containsKey('onClick'), isFalse);
      expect(
        button.props['style'],
        containsPair('background', 'var(--color-successSolid, #079455)'),
      );
      expect(button.props['style'], containsPair('min-height', '34px'));
      expect(button.children.first, isA<Spinner>());
      expect(button.children.last, isA<Text>());
    });

    test('renders scoped variant interaction states', () {
      final button = Button(
        child: 'Save',
        variant: ButtonVariant.outline,
        tone: Tone.primary,
      );

      expect(button.props['className'], contains('flint-s-'));
      expect(
        button.props['style'],
        containsPair('color', 'var(--color-primaryText, #1849a9)'),
      );
      expect(button.props['_flintStyleCss'], contains(':hover'));
      expect(
        button.props['_flintStyleCss'],
        contains('background: var(--color-primarySoft, #eff4ff) !important'),
      );
      expect(button.props['_flintStyleCss'], contains(':focus-visible'));
      expect(button.props['_flintStyleCss'], contains(':active'));
    });

    test('keeps explicit styles as the final override', () {
      final button = Button(
        child: 'Delete',
        tone: Tone.danger,
        style: {'background': '#000', 'padding': '2px'},
      );

      expect(button.props['style'], containsPair('background', '#000'));
      expect(button.props['style'], containsPair('padding', '2px'));
    });
  });

  group('IconButton', () {
    test('renders accessible icon-only button', () {
      final button = IconButton(
        icon: Text('X'),
        label: 'Close',
        tooltip: 'Close panel',
      );

      expect(button.props['aria-label'], 'Close');
      expect(button.props['title'], 'Close panel');
      expect(button.children.single, isA<Text>());
    });
  });

  group('Icon', () {
    test('renders decorative inline SVG icons from the built-in catalog', () {
      final icon = Icon(Icons.home, size: 24, color: '#155eef');

      expect(icon.tag, 'svg');
      expect(icon.props['aria-hidden'], 'true');
      expect(icon.props['viewBox'], '0 0 24 24');
      expect(icon.props['stroke'], 'currentColor');
      expect(icon.props['style'], containsPair('width', '24px'));
      expect(icon.props['style'], containsPair('height', '24px'));
      expect(icon.props['style'], containsPair('color', '#155eef'));
      expect(icon.children, isNotEmpty);
      expect((icon.children.first as FlintElement).tag, 'path');
    });

    test('renders accessible labelled icons', () {
      final icon = Icon(Icons.search, title: 'Search');

      expect(icon.props['role'], 'img');
      expect(icon.props['aria-label'], 'Search');
      expect(icon.props.containsKey('aria-hidden'), isFalse);
      expect((icon.children.first as FlintElement).tag, 'title');
      expect(
        (icon.children.first as FlintElement).children.single,
        isA<FlintText>(),
      );
    });

    test('accepts DartStyle with explicit style as final override', () {
      final icon = Icon(
        Icons.user,
        size: 24,
        dartStyle: const DartStyle(color: '#155eef', margin: EdgeInsets.all(4)),
        style: const {'color': '#111827'},
      );

      expect(icon.props['style'], containsPair('width', '24px'));
      expect(icon.props['style'], containsPair('height', '24px'));
      expect(icon.props['style'], containsPair('margin', '4px'));
      expect(icon.props['style'], containsPair('color', '#111827'));
    });

    test('supports scoped DartStyle states', () {
      final icon = Icon(
        Icons.settings,
        dartStyle: const DartStyle(hover: DartStyle(color: '#0f766e')),
      );

      expect(icon.props['className'], contains('flint-s-'));
      expect(icon.props['_flintStyleCss'], contains(':hover'));
      expect(
        icon.props['_flintStyleCss'],
        contains('color: #0f766e !important'),
      );
    });

    test('ships a broad app icon catalog', () {
      expect(Icons.all.length, greaterThanOrEqualTo(80));
      expect(Icons.all.map((icon) => icon.name), contains('code'));
      expect(Icons.all.map((icon) => icon.name), contains('gitBranch'));
      expect(Icons.all.map((icon) => icon.name), contains('server'));
      expect(Icons.all.map((icon) => icon.name), contains('settings'));
      expect(Icons.all.map((icon) => icon.name), contains('route'));
      expect(Icons.all.map((icon) => icon.name), contains('shoppingCart'));
      expect(Icons.all.map((icon) => icon.name), contains('sparkles'));
    });
  });

  group('ButtonGroup', () {
    test('renders inline action grouping', () {
      final group = ButtonGroup(
        children: [
          Button(child: 'Save'),
          Button(child: 'Cancel', variant: ButtonVariant.outline),
        ],
      );

      expect(group.tag, 'div');
      expect(group.props['style'], containsPair('display', 'inline-flex'));
      expect(group.children, hasLength(2));
    });
  });

  group('text and link primitives', () {
    test('Text helpers render semantic text elements with DartStyle', () {
      final title = Text.h1(
        'Dashboard',
        className: 'page-title',
        dartStyle: const DartStyle(fontSize: 28),
      );

      expect(title.tag, 'h1');
      expect(title.props['className'], 'page-title');
      expect(title.props['style'], containsPair('font-size', '28px'));
      expect((title.children.single as FlintText).value, 'Dashboard');
    });

    test('Link renders anchor props and children', () {
      final link = Link(
        href: '/dashboard',
        className: 'text-link',
        child: 'Open dashboard',
      );

      expect(link.tag, 'a');
      expect(link.props['href'], '/dashboard');
      expect(link.props['className'], 'text-link');
      expect((link.children.single as FlintText).value, 'Open dashboard');
    });

    test('Link supports action variants', () {
      final link = Link(
        href: '/contact',
        variant: ButtonVariant.solid,
        tone: Tone.primary,
        size: ComponentSize.lg,
        child: 'Contact',
      );

      expect(link.tag, 'a');
      expect(link.props['href'], '/contact');
      expect(link.props['className'], contains('flint-s-'));
      expect(
        link.props['style'],
        containsPair('background', 'var(--color-primarySolid, #155eef)'),
      );
      expect(link.props['style'], containsPair('min-height', '46px'));
      expect(link.props['_flintStyleCss'], contains(':hover'));
    });
  });

  group('media primitives', () {
    test('Image renders responsive image attributes and styles', () {
      final image = Image(
        src: '/assets/logo.png',
        alt: 'EuPanel logo',
        width: 96,
        height: 96,
        loading: ImageLoading.eager,
        dartStyle: const DartStyle(radius: 12),
      );

      expect(image.tag, 'img');
      expect(image.props['src'], '/assets/logo.png');
      expect(image.props['alt'], 'EuPanel logo');
      expect(image.props['width'], '96px');
      expect(image.props['height'], '96px');
      expect(image.props['loading'], 'eager');
      expect(image.props['decoding'], 'async');
      expect(image.props['style'], containsPair('max-width', '100%'));
      expect(image.props['style'], containsPair('border-radius', '12px'));
    });

    test('Figure renders image content and caption', () {
      final figure = Figure(
        image: Image(src: '/screens/dashboard.png', alt: 'Dashboard'),
        caption: 'Dashboard preview',
      );

      expect(figure.tag, 'figure');
      expect(figure.children.first, isA<Image>());
      expect(figure.children.last, isA<FlintElement>());
      expect((figure.children.last as FlintElement).tag, 'figcaption');
    });
  });

  group('navigation components', () {
    test('Tabs support nav variants and interaction states', () {
      final tabs = Tabs(
        activeKey: 'profile',
        variant: NavVariant.pill,
        tone: Tone.info,
        size: ComponentSize.sm,
        tabs: const [
          TabItem(key: 'home', label: 'Home'),
          TabItem(key: 'profile', label: 'Profile'),
        ],
      );

      final selected = tabs.children[1] as FlintElement;
      expect(selected.props['aria-selected'], 'true');
      expect(selected.props['className'], contains('flint-s-'));
      expect(
        selected.props['style'],
        containsPair('background', 'var(--color-infoSoft, #eff8ff)'),
      );
      expect(selected.props['style'], containsPair('min-height', '34px'));
      expect(selected.props['_flintStyleCss'], contains(':hover'));
      expect(selected.props['_flintStyleCss'], contains(':focus-visible'));
    });

    test('Pagination uses button variants for current and disabled states', () {
      final pagination = Pagination(page: 2, pageSize: 10, total: 24);
      final controls = pagination.children[1] as FlintElement;
      final current = controls.children[2] as FlintElement;
      final next = controls.children[4] as FlintElement;

      expect(current.props['aria-current'], 'page');
      expect(
        current.props['style'],
        containsPair('background', 'var(--color-primarySoft, #eff4ff)'),
      );
      expect(next.props['style'], containsPair('min-width', '34px'));
      expect(next.props['_flintStyleCss'], contains(':hover'));
    });
  });

  group('feedback components', () {
    test('Spinner renders status semantics', () {
      final spinner = Spinner(label: 'Loading users', tone: Tone.info);

      expect(spinner.props['role'], 'status');
      expect(
        spinner.props['style'],
        containsPair('border-top-color', 'var(--color-infoSolid, #1570ef)'),
      );
      expect(
        spinner.props['style'],
        containsPair(
          'animation',
          'flint-spin 800ms linear infinite normal none running',
        ),
      );
      expect(spinner.props['style'], containsPair('will-change', 'transform'));
      expect(spinner.children.single, isA<FlintText>());
    });

    test('Alert renders title, message, tone, and actions', () {
      final alert = Alert(
        title: 'Saved',
        message: 'The user was updated.',
        tone: Tone.success,
        actions: Button(child: 'Undo', variant: ButtonVariant.ghost),
      );

      expect(alert.props['role'], 'alert');
      expect(
        alert.props['style'],
        containsPair('background', 'var(--color-successSoft, #ecfdf3)'),
      );
      expect(alert.children, hasLength(3));
      expect(alert.children.first, isA<FlintElement>());
      expect(alert.children.last, isA<Button>());
    });

    test('StatusBadge renders label and tone style', () {
      final badge = StatusBadge(label: 'Active', tone: Tone.success);

      expect(badge.tag, 'span');
      expect(
        badge.props['style'],
        containsPair('background', 'var(--color-successSoft, #ecfdf3)'),
      );
      expect((badge.children.single as FlintText).value, 'Active');
    });

    test('StatusBadge supports outline and solid variants', () {
      final outline = StatusBadge(
        label: 'Review',
        tone: Tone.warning,
        variant: BadgeVariant.outline,
      );
      final solid = StatusBadge(
        label: 'Live',
        tone: Tone.success,
        variant: BadgeVariant.solid,
      );

      expect(outline.props['style'], containsPair('background', 'transparent'));
      expect(
        outline.props['style'],
        containsPair('color', 'var(--color-warningText, #b54708)'),
      );
      expect(
        solid.props['style'],
        containsPair('background', 'var(--color-successSolid, #079455)'),
      );
      expect(
        solid.props['style'],
        containsPair('color', 'var(--color-onSolid, #ffffff)'),
      );
    });
  });
}
