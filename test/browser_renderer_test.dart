@TestOn('browser')
library;

import 'dart:async';

import 'package:flint_ui/flint_ui.dart';
import 'package:test/test.dart';
import 'package:universal_web/web.dart' as web;

void main() {
  group('browser renderer', () {
    test(
      'restores caret on the active repeated input after rerender',
      () async {
        final host = web.document.createElement('div');
        web.document.body?.appendChild(host);
        addTearDown(() => host.remove());

        final root = createRootForElement(host);
        root.render(_repeatedFields('Alpha', 'Bravo'));
        await _flushRender();

        final inputs = host.querySelectorAll('input');
        final second = inputs.item(1) as web.HTMLInputElement;
        second.focus();
        await _flushRender();
        second.setSelectionRange(2, 2);
        expect(second.selectionStart, 2);

        root.render(_repeatedFields('Alpha', 'Bravo updated'));
        await _flushRender();

        final updatedInputs = host.querySelectorAll('input');
        final updatedSecond = updatedInputs.item(1) as web.HTMLInputElement;

        expect(web.document.activeElement, updatedSecond);
        expect(updatedSecond.selectionStart, 2);
        expect(updatedSecond.selectionEnd, 2);
      },
    );
  });
}

FlintElement _repeatedFields(String first, String second) {
  return div(
    children: [
      TextField(name: 'variant-title', value: first),
      TextField(name: 'variant-title', value: second),
    ],
  );
}

Future<void> _flushRender() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}
