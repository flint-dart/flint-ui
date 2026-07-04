import 'package:flint_ui/flint_ui.dart';

void main() {
  createFlintApp(
    '#app',
    themeMode: FlintThemeMode.light,
    pages: {'Home': (_) => ExampleHomePage()},
  );
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
        child: Column(
          dartStyle: const DartStyle(gap: 18),
          children: [
            ThemeModeToggle(),
            ResponsiveGrid(
              minItemWidth: 224,
              children: [
                StatCard(label: 'Components', value: '60+'),
                StatCard(label: 'Styles', value: 'Typed'),
                StatCard(label: 'Runtime', value: 'Browser'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeModeToggle extends FlintComponent {
  @override
  FlintNode build() {
    return StateSignalListener(flintTheme.mode, (mode) {
      final isDark = mode == FlintThemeMode.dark;

      return Container(
        dartStyle: DartStyle(
          display: Display.flex,
          alignItems: AlignItems.center,
          justifyContent: JustifyContent.between,
          gap: 12,
          padding: const EdgeInsets.all(16),
          radius: ThemeToken.radius('md'),
          background: ThemeToken.color('surface'),
          color: ThemeToken.color('text'),
          light: DartStyle(border: Border.all(color: Colors.slate200)),
          dark: DartStyle(
            border: Border.all(color: Color.rgba(148, 163, 184, 0.24)),
            shadow: ThemeToken.shadow('card'),
          ),
        ),
        children: [
          Column(
            dartStyle: const DartStyle(gap: 4),
            children: [
              Text.strong('Theme mode'),
              Text.span(
                isDark ? 'Dark tokens are active' : 'Light tokens are active',
              ),
            ],
          ),
          Button(
            child: isDark ? 'Use light' : 'Use dark',
            onPressed: (_) => flintTheme.toggle(),
          ),
        ],
      );
    });
  }
}
