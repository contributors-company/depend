import 'package:depend/depend.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class TestInjectionScopeLibrary extends Injection<TestInjectionScopeLibrary> {
  @override
  Future<void> init() async {
    // Имитируем инициализацию
    await Future.delayed(const Duration(milliseconds: 100), () {});
  }
}

class FaultyInjectionScopeLibrary
    extends Injection<FaultyInjectionScopeLibrary> {
  FaultyInjectionScopeLibrary();

  @override
  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 100), () {});

    // Выбрасываем исключение
    throw Exception('Initialization failed');
  }
}

class MockLibrary extends Injection<void> {
  MockLibrary() : super();

  @override
  Future<void> init() async {}
}

void main() {
  group('InjectionScope Widget', () {
    testWidgets('maybeOf should find the library in the widget tree',
        (tester) async {
      // Создаем виджет, в котором обернут наш Dependencies.
      await tester.pumpWidget(
        InjectionScope<MockLibrary>(
          injection: MockLibrary(),
          child: Builder(
            builder: (context) {
              // Вызываем maybeOf внутри контекста, чтобы проверить извлечение.
              final library =
                  InjectionScope.maybeOf<MockLibrary>(context, listen: true);
              expect(library, isNotNull);
              return Container();
            },
          ),
        ),
      );
    });

    test('updateShouldNotify returns true when libraries are different', () {
      final oldLibrary = MockLibrary();
      final newLibrary = MockLibrary();

      final oldDependencies = InjectionScope(
        injection: oldLibrary,
        child: const SizedBox(),
      );

      final newDependencies = InjectionScope(
        injection: newLibrary,
        child: const SizedBox(),
      );

      // Проверяем, что updateShouldNotify вернет true, если библиотеки разные
      expect(newDependencies.updateShouldNotify(oldDependencies), isTrue);
    });

    test('updateShouldNotify returns false when libraries are the same', () {
      final library = MockLibrary();

      final oldDependencies = InjectionScope(
        injection: library,
        child: const SizedBox(),
      );

      final newDependencies = InjectionScope(
        injection: library,
        child: const SizedBox(),
      );

      // Проверяем, что updateShouldNotify вернет false, если библиотеки одинаковые
      expect(newDependencies.updateShouldNotify(oldDependencies), isFalse);
    });

    testWidgets('maybeOf should return null when library is not found',
        (tester) async {
      // Проверяем, что if no Dependencies widget is found, maybeOf returns null.
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final library =
                InjectionScope.maybeOf<MockLibrary>(context, listen: true);
            expect(library, isNull);
            return Container();
          },
        ),
      );
    });

    testWidgets('Предоставляет library потомкам', (tester) async {
      final library = TestInjectionScopeLibrary();

      await tester.pumpWidget(
        InjectionScope<TestInjectionScopeLibrary>(
          injection: library,
          child: Builder(
            builder: (context) {
              final retrievedLibrary =
                  InjectionScope.of<TestInjectionScopeLibrary>(context);
              expect(retrievedLibrary, equals(library));
              return Container();
            },
          ),
        ),
        const Duration(milliseconds: 200),
      );
    });

    testWidgets('Показывает placeholder во время инициализации',
        (tester) async {
      final library = TestInjectionScopeLibrary();
      const placeholderKey = Key('placeholder');

      await tester.pumpWidget(
        InjectionScope<TestInjectionScopeLibrary>(
          injection: library,
          placeholder: Container(key: placeholderKey),
          child: Container(),
        ),
      );

      expect(find.byKey(placeholderKey), findsOneWidget);

      // Ждем завершения инициализации
      await tester.pumpAndSettle();

      expect(find.byKey(placeholderKey), findsNothing);
    });

    testWidgets('Child отображается после инициализации', (tester) async {
      final library = TestInjectionScopeLibrary();
      const childKey = Key('child');

      await tester.pumpWidget(
        InjectionScope<TestInjectionScopeLibrary>(
          injection: library,
          child: const SizedBox(key: childKey),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('maybeOf возвращает null, если не найдено', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final library =
                InjectionScope.maybeOf<TestInjectionScopeLibrary>(context);
            expect(library, isNull);
            return Container();
          },
        ),
      );
    });

    testWidgets('of бросает исключение, если зависимость не найдена',
        (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(() => InjectionScope.of<TestInjectionScopeLibrary>(context),
                throwsArgumentError);
            return Container();
          },
        ),
      );
    });

    testWidgets('Обрабатывает ошибку инициализации в методе init',
        (tester) async {
      final library = FaultyInjectionScopeLibrary();

      await tester.pumpWidget(
        InjectionScope<FaultyInjectionScopeLibrary>(
          injection: library,
          placeholder: Container(key: const Key('placeholder')),
          child:
              Builder(builder: (context) => Container(key: const Key('child'))),
        ),
      );

      expect(find.byKey(const Key('placeholder')), findsOneWidget);
      expect(find.byKey(const Key('child')), findsNothing);
      expect(find.byType(ErrorWidget), findsNothing);

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('placeholder')), findsNothing);
      expect(find.byKey(const Key('child')), findsNothing);
      expect(find.byType(ErrorWidget), findsOneWidget);
    });
  });
}
