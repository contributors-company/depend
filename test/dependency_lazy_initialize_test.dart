import 'package:depend/depend.dart';
import 'package:flutter_test/flutter_test.dart';

class _Service {
  _Service() {
    initCount++;
  }

  int initCount = 0;
}

class _AsyncService {
  _AsyncService(this.name);

  final String name;

  static Future<_AsyncService> init(String name) async => _AsyncService(name);
}

void main() {
  group('LazyGet', () {
    test('не вызывает фабрику до первого обращения', () {
      var callCount = 0;

      final lazy = LazyGet(() {
        callCount++;
        return _Service();
      });

      // Фабрика ещё не вызвана
      expect(callCount, 0);

      lazy.instance;

      // Фабрика вызвана один раз
      expect(callCount, 1);
    });

    test('возвращает один и тот же экземпляр при повторных обращениях', () {
      final lazy = LazyGet(_Service.new);

      final first = lazy.instance;
      final second = lazy.instance;
      final third = lazy.instance;

      expect(identical(first, second), isTrue);
      expect(identical(second, third), isTrue);
    });

    test('не создаёт объект более одного раза', () {
      var callCount = 0;

      final lazy = LazyGet(() {
        callCount++;
        return _Service();
      });

      for (var i = 0; i < 3; i++) {
        lazy.instance;
      }

      expect(callCount, 1);
    });

    test('возвращает корректное значение из фабрики', () {
      final lazy = LazyGet(_Service.new);

      expect(lazy.instance, isA<_Service>());
      expect(lazy.instance.initCount, 1);
    });
  });

  group('LazyFutureGet', () {
    test('не вызывает фабрику до первого обращения', () async {
      var callCount = 0;

      final lazy = LazyFutureGet(() async {
        callCount++;
        return _AsyncService.init('test');
      });

      // Фабрика ещё не вызвана
      expect(callCount, 0);

      await lazy.instance;

      // Фабрика вызвана один раз
      expect(callCount, 1);
    });

    test(
      'возвращает один и тот же экземпляр при повторных обращениях',
      () async {
        final lazy = LazyFutureGet(() async => _AsyncService.init('singleton'));

        final first = await lazy.instance;
        final second = await lazy.instance;

        expect(identical(first, second), isTrue);
      },
    );

    test(
      'не создаёт объект более одного раза при последовательных вызовах',
      () async {
        var callCount = 0;

        final lazy = LazyFutureGet(() async {
          callCount++;
          return _AsyncService.init('test');
        });

        await lazy.instance;
        await lazy.instance;
        await lazy.instance;

        expect(callCount, 1);
      },
    );

    test('параллельные вызовы используют один и тот же Future', () async {
      var callCount = 0;

      final lazy = LazyFutureGet(() async {
        callCount++;
        return _AsyncService.init('parallel');
      });

      // Несколько одновременных обращений — фабрика должна вызваться только один раз
      final results = await Future.wait([
        lazy.instance,
        lazy.instance,
        lazy.instance,
      ]);

      expect(callCount, 1);
      expect(results.every((s) => identical(s, results.first)), isTrue);
    });

    test('возвращает корректное значение из фабрики', () async {
      final lazy = LazyFutureGet(() async => _AsyncService.init('my-service'));

      final service = await lazy.instance;

      expect(service, isA<_AsyncService>());
      expect(service.name, 'my-service');
    });
  });
}
