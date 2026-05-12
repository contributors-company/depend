import 'package:depend/depend.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LazyGet', () {
    test('does not call factory until instance is accessed', () {
      var callCount = 0;
      final lazy = LazyGet(() {
        callCount++;
        return 'value';
      });

      expect(callCount, 0);
      lazy.instance;
      expect(callCount, 1);
    });

    test('calls factory only once on multiple accesses', () {
      var callCount = 0;
      final lazy = LazyGet(() {
        callCount++;
        return 'value';
      });

      for (var i = 0; i < 3; i++) {
        lazy.instance;
      }

      expect(callCount, 1);
    });

    test('returns the same instance on every access', () {
      final lazy = LazyGet(Object.new);

      final first = lazy.instance;
      final second = lazy.instance;

      expect(identical(first, second), isTrue);
    });

    test('returns correct value from factory', () {
      final lazy = LazyGet(() => 42);

      expect(lazy.instance, 42);
    });

    test('works with complex objects', () {
      final lazy = LazyGet(() => {'key': 'value'});

      expect(lazy.instance, {'key': 'value'});
    });
  });

  group('LazyFutureGet', () {
    test('does not call factory until instance is accessed', () async {
      var callCount = 0;
      final lazy = LazyFutureGet(() async {
        callCount++;
        return 'value';
      });

      expect(callCount, 0);
      await lazy.instance;
      expect(callCount, 1);
    });

    test('calls factory only once on multiple sequential accesses', () async {
      var callCount = 0;
      final lazy = LazyFutureGet(() async {
        callCount++;
        return 'value';
      });

      await lazy.instance;
      await lazy.instance;
      await lazy.instance;

      expect(callCount, 1);
    });

    test('returns the same instance on every access', () async {
      final lazy = LazyFutureGet(() async => Object());

      final first = await lazy.instance;
      final second = await lazy.instance;

      expect(identical(first, second), isTrue);
    });

    test('returns correct value from factory', () async {
      final lazy = LazyFutureGet(() async => 99);

      expect(await lazy.instance, 99);
    });

    test('concurrent calls share the same pending future', () async {
      var callCount = 0;
      final lazy = LazyFutureGet(() async {
        callCount++;
        return 'value';
      });

      final results = await Future.wait([
        lazy.instance,
        lazy.instance,
        lazy.instance,
      ]);

      expect(callCount, 1);
      expect(results, ['value', 'value', 'value']);
    });

    test('resolves correctly after async delay', () async {
      final lazy = LazyFutureGet(() async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return 'delayed';
      });

      expect(await lazy.instance, 'delayed');
      expect(await lazy.instance, 'delayed');
    });
  });
}
