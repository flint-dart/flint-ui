import 'package:flint_ui/src/state/state_signal.dart';
import 'package:test/test.dart';

void main() {
  group('StateSignal', () {
    test('notifies listeners when value changes', () {
      final count = StateSignal<int>(0);
      final values = <int>[];

      count.listen(values.add);
      count.value = 1;
      count.update((value) => value + 1);

      expect(values, [1, 2]);
      expect(count.value, 2);
    });

    test('can fire immediately and unsubscribe', () {
      final name = StateSignal<String>('Flint');
      final values = <String>[];

      final unsubscribe = name.listen(values.add, fireImmediately: true);
      name.value = 'Dart';
      unsubscribe();
      name.value = 'UI';

      expect(values, ['Flint', 'Dart']);
    });

    test('can notify listeners without changing the value', () {
      final items = StateSignal<List<String>>([]);
      var calls = 0;

      items.listen((_) => calls++);
      items.value.add('answer');
      items.notifyListeners();

      expect(items.value, ['answer']);
      expect(calls, 1);
    });

    test('StateSignalListener builds from the current signal value', () {
      final count = StateSignal<int>(1);
      final listener = StateSignalListener<int>(
        count,
        (value) => 'count: $value',
      );

      expect(listener.build(), 'count: 1');
      count.value = 2;
      expect(listener.build(), 'count: 2');
    });
  });
}
