import 'package:depend/depend.dart'; // Замените на фактический путь
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class TestDependenciesLibrary
    extends DependenciesLibrary<TestDependenciesLibrary> {
  @override
  Future<void> init() async {
    // Имитируем инициализацию
    await log(() async {
      await Future.delayed(const Duration(milliseconds: 100), () {});
      return null;
    });
  }
}

class FaultyDependenciesLibrary
    extends DependenciesLibrary<FaultyDependenciesLibrary> {
  FaultyDependenciesLibrary();

  @override
  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 100), () {});

    // Выбрасываем исключение
    throw Exception('Initialization failed');
  }
}

void main() {
  group('Dependencies Widget', () {
    testWidgets('Предоставляет library потомкам', (tester) async {
      final library = TestDependenciesLibrary();

      await tester.pumpWidget(
        Dependencies<TestDependenciesLibrary>(
          library: library,
          child: Builder(
            builder: (context) {
              final retrievedLibrary =
                  Dependencies.of<TestDependenciesLibrary>(context);
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
      final library = TestDependenciesLibrary();
      const placeholderKey = Key('placeholder');

      await tester.pumpWidget(
        Dependencies<TestDependenciesLibrary>(
          library: library,
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
      final library = TestDependenciesLibrary();
      const childKey = Key('child');

      await tester.pumpWidget(
        Dependencies<TestDependenciesLibrary>(
          library: library,
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
                Dependencies.maybeOf<TestDependenciesLibrary>(context);
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
            expect(() => Dependencies.of<TestDependenciesLibrary>(context),
                throwsArgumentError);
            return Container();
          },
        ),
      );
    });

    testWidgets('Обрабатывает ошибку инициализации в методе init',
        (tester) async {
      final library = FaultyDependenciesLibrary();

      await tester.pumpWidget(
        Dependencies<FaultyDependenciesLibrary>(
          library: library,
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
