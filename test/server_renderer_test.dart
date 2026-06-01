import 'package:flint_ui/flint_ui_server.dart';
import 'package:test/test.dart';

void main() {
  group('FlintServerRenderer', () {
    test('renders text, elements, attributes, and styles safely', () {
      final html = const FlintServerRenderer().render(
        h(
          'section',
          props: {
            'className': 'hero',
            'style': {'color': 'red', 'font-weight': 700},
            'data-title': 'A "quote"',
            'onClick': (_) {},
          },
          children: [
            h('h1', children: ['Hello <Flint>']),
            input(props: {'disabled': true, 'value': 'Ready'}),
          ],
        ),
      );

      expect(
        html,
        '<section class="hero" style="color: red; font-weight: 700" '
        'data-title="A &quot;quote&quot;"><h1>Hello &lt;Flint&gt;</h1>'
        '<input disabled value="Ready"></section>',
      );
      expect(html, isNot(contains('onClick')));
    });

    test('renders registered page components', () {
      final registry = FlintComponentRegistry({
        'Home': (props) => _GreetingPage(props['name']?.toString() ?? ''),
      });

      final html = const FlintServerRenderer().renderPage(
        registry,
        'Home',
        props: {'name': 'Ada'},
      );

      expect(html, '<main><p>Hello Ada</p></main>');
    });

    test('renders scoped styles before HTML', () {
      final html = const FlintServerRenderer().render(
        div(
          props: {
            'className': 'flint-s-test',
            '_flintStyleCss': '.flint-s-test:hover { color: red; }',
          },
          children: ['Hover'],
        ),
      );

      expect(html, startsWith('<style data-flint-ssr-style>'));
      expect(html, contains('.flint-s-test:hover { color: red; }'));
      expect(html, endsWith('<div class="flint-s-test">Hover</div>'));
    });
  });
}

class _GreetingPage extends StatelessComponent {
  _GreetingPage(this.name);

  final String name;

  @override
  View build() {
    return h('main', children: [
      h('p', children: ['Hello $name']),
    ]);
  }
}
