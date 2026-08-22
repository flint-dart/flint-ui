# 📦 Flint UI is now natively built into Flint Dart!

<div align="center">

[![Repository Moved](https://img.shields.io/badge/Repository-Moved%20to%20Flint%20Dart-blue.svg?style=flat-square&logo=dart)](https://github.com/flint-dart/flint_dart)
[![Pub.dev](https://img.shields.io/pub/v/flint_dart.svg?style=flat-square&logo=dart)](https://pub.dev/packages/flint_dart)
[![Documentation](https://img.shields.io/badge/docs-flintdart.dev-green.svg?style=flat-square)](https://flintdart.dev)

</div>

---

> [!IMPORTANT]
> **Flint UI is now an official, built-in core module of [Flint Dart](https://github.com/flint-dart/flint_dart).**
> To simplify the ecosystem and provide a seamless full-stack experience, all UI widgets, declarative components, WebGL 3D scenes, Canvas engines, and Server-Side Rendering (SSR) are now maintained directly inside the **[`flint_dart`](https://github.com/flint-dart/flint_dart)** package.

---

## 🚀 How to Use Flint UI Today

You no longer need a separate `flint_ui` dependency. Simply add `flint_dart` to your project:

### 1. Add `flint_dart`
```bash
dart pub add flint_dart
```

### 2. Import and Build
```dart
import 'package:flint_dart/ui.dart';

class MyPage extends FlintComponent {
  MyPage(super.props);

  @override
  FlintNode build() {
    return AppShell(
      topbar: Topbar(title: 'Flint Fullstack App'),
      child: Column(
        children: [
          Text('Built with Flint Dart', style: TextStyle(size: 24, weight: '700')),
          Button(
            label: 'Explore Docs',
            variant: ButtonVariant.solid,
            href: 'https://flintdart.dev',
          ),
        ],
      ),
    );
  }
}
```

---

## 🔗 Official Links

* **Main Fullstack Framework**: [github.com/flint-dart/flint_dart](https://github.com/flint-dart/flint_dart)
* **Pub.dev Package**: [pub.dev/packages/flint_dart](https://pub.dev/packages/flint_dart)
* **Documentation & Guides**: [flintdart.dev](https://flintdart.dev)
* **Issue Tracker**: [github.com/flint-dart/flint_dart/issues](https://github.com/flint-dart/flint_dart/issues)
