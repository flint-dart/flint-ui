import 'package:flint_ui/flint_ui.dart';

void main() {
  createFlintApp('#app', pages: {'Home': (_) => ExampleHomePage()});
}

class ExampleHomePage extends FlintComponent {
  @override
  FlintNode build() {
    return PageShell(
      header: PageHeader(
        title: 'Flint UI Example',
        description: 'A Dart-first interface composed from Flint UI widgets.',
        actions: Button(
          child: 'Open Docs',
          onPressed: (_) => navigation.assign('https://flintdart.dev'),
        ),
      ),
      child: Section(
        title: 'Build UI in Dart',
        description:
            'Use typed styles, reusable components, and browser APIs without hand-writing every HTML node.',
        child: ResponsiveGrid(
          minItemWidth: 224,
          children: [
            StatCard(label: 'Components', value: '60+'),
            StatCard(label: 'Styles', value: 'Typed'),
            StatCard(label: 'Runtime', value: 'Browser'),
          ],
        ),
      ),
    );
  }
}
