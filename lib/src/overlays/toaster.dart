import 'dart:async';

import 'package:universal_web/web.dart' as web;

enum ToastPlacement { topRight, topCenter, bottomRight, bottomCenter }

class ToastService {
  const ToastService();

  void info(
    String title, {
    String? message,
    Duration duration = const Duration(seconds: 3),
    ToastPlacement placement = ToastPlacement.topRight,
  }) {
    _show(
      title,
      message: message,
      duration: duration,
      placement: placement,
      background: '#0f172a',
      border: 'rgba(125, 211, 252, 0.36)',
      accent: '#7dd3fc',
    );
  }

  void success(
    String title, {
    String? message,
    Duration duration = const Duration(seconds: 3),
    ToastPlacement placement = ToastPlacement.topRight,
  }) {
    _show(
      title,
      message: message,
      duration: duration,
      placement: placement,
      background: '#052e22',
      border: 'rgba(52, 211, 153, 0.38)',
      accent: '#a7f3d0',
    );
  }

  void warning(
    String title, {
    String? message,
    Duration duration = const Duration(seconds: 4),
    ToastPlacement placement = ToastPlacement.topRight,
  }) {
    _show(
      title,
      message: message,
      duration: duration,
      placement: placement,
      background: '#422006',
      border: 'rgba(251, 191, 36, 0.4)',
      accent: '#fbbf24',
    );
  }

  void error(
    String title, {
    String? message,
    Duration duration = const Duration(seconds: 5),
    ToastPlacement placement = ToastPlacement.topRight,
  }) {
    _show(
      title,
      message: message,
      duration: duration,
      placement: placement,
      background: '#450a0a',
      border: 'rgba(248, 113, 113, 0.42)',
      accent: '#fca5a5',
    );
  }

  void _show(
    String title, {
    required Duration duration,
    required ToastPlacement placement,
    required String background,
    required String border,
    required String accent,
    String? message,
  }) {
    final container = _container(placement);
    final item = web.document.createElement('div') as web.HTMLDivElement;
    item.style
      ..display = 'grid'
      ..gap = '4px'
      ..minWidth = '260px'
      ..maxWidth = '360px'
      ..padding = '12px 14px'
      ..borderRadius = '10px'
      ..border = '1px solid $border'
      ..background = background
      ..color = '#f8fafc'
      ..boxShadow = '0 18px 48px rgba(0, 0, 0, 0.28)'
      ..transform = 'translateY(-6px)'
      ..opacity = '0'
      ..transition = 'opacity 160ms ease, transform 160ms ease';

    final titleEl = web.document.createElement('strong') as web.HTMLElement;
    titleEl.textContent = title;
    titleEl.style
      ..fontSize = '13px'
      ..fontWeight = '800'
      ..color = accent;
    item.appendChild(titleEl);

    if (message != null && message.trim().isNotEmpty) {
      final messageEl = web.document.createElement('p') as web.HTMLElement;
      messageEl.textContent = message;
      messageEl.style
        ..margin = '0'
        ..fontSize = '12px'
        ..lineHeight = '1.5'
        ..color = '#cbd5e1';
      item.appendChild(messageEl);
    }

    container.appendChild(item);
    Timer.run(() {
      item.style
        ..opacity = '1'
        ..transform = 'translateY(0)';
    });

    Timer(duration, () {
      item.style
        ..opacity = '0'
        ..transform = 'translateY(-6px)';
      Timer(const Duration(milliseconds: 180), () {
        item.remove();
        if (container.childElementCount == 0) container.remove();
      });
    });
  }

  web.HTMLDivElement _container(ToastPlacement placement) {
    final id = 'flint-toast-${placement.name}';
    final existing = web.document.getElementById(id);
    if (existing is web.HTMLDivElement) return existing;

    final el = web.document.createElement('div') as web.HTMLDivElement;
    el.id = id;
    el.style
      ..position = 'fixed'
      ..zIndex = '2147483647'
      ..display = 'grid'
      ..gap = '10px'
      ..pointerEvents = 'none';

    switch (placement) {
      case ToastPlacement.topRight:
        el.style
          ..top = '16px'
          ..right = '16px';
        break;
      case ToastPlacement.topCenter:
        el.style
          ..top = '16px'
          ..left = '50%'
          ..transform = 'translateX(-50%)';
        break;
      case ToastPlacement.bottomRight:
        el.style
          ..right = '16px'
          ..bottom = '16px';
        break;
      case ToastPlacement.bottomCenter:
        el.style
          ..left = '50%'
          ..bottom = '16px'
          ..transform = 'translateX(-50%)';
        break;
    }

    web.document.body?.appendChild(el);
    return el;
  }
}

const toast = ToastService();
