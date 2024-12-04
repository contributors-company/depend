import 'package:depend/depend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Фейковая реализация DependencyContainer
class MockDependencyContainer extends Mock
    implements DependencyContainer<Object?> {}

class MockExceptionDependencyContainer extends Mock
    implements DependencyContainer<Object?> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DependencyScope Tests', () {
    testWidgets('renders placeholder when initializing', (tester) async {
      final mockDependency = MockDependencyContainer();

      when(mockDependency.init).thenAnswer((_) async {});
      when(mockDependency.inject).thenAnswer((_) async {});

      // Строим виджет с placeholder
      await tester.pumpWidget(
        DependencyScope<MockDependencyContainer>(
          dependency: mockDependency,
          builder: (context) => Container(),
          placeholder: const CircularProgressIndicator(),
        ),
      );

      // Ожидаем, что будет отображаться placeholder
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Завершаем инициализацию
      await tester.pumpAndSettle();

      // Ожидаем, что виджет будет обновлен, и placeholder исчезнет
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders errorBuilder when init fails', (tester) async {
      final mockDependency = MockExceptionDependencyContainer();

      when(mockDependency.inject).thenAnswer((_) async {
        throw Exception();
      });

      // Строим виджет с errorBuilder
      await tester.pumpWidget(
        MaterialApp(
          home: DependencyScope<MockExceptionDependencyContainer>(
            dependency: mockDependency,
            builder: (context) => Container(),
            errorBuilder: (context) =>
                const Text('Error: Initialization error'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Ожидаем, что будет отображено сообщение об ошибке
      await expectLater(
          find.text('Error: Initialization error'), findsOneWidget);
    });

    testWidgets('renders errorBuilder when init fails', (tester) async {
      final mockDependency = MockDependencyContainer();

      when(mockDependency.inject).thenAnswer((_) async {
        throw Exception();
      });

      // Строим виджет с errorBuilder
      await tester.pumpWidget(
        MaterialApp(
          home: DependencyScope<MockDependencyContainer>(
            dependency: mockDependency,
            builder: (context) => Container(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Ожидаем, что будет отображено сообщение об ошибке
      await expectLater(find.byType(ErrorWidget), findsOneWidget);
    });

    testWidgets('calls dispose when the widget is disposed', (tester) async {
      final mockDependency = MockDependencyContainer();

      when(mockDependency.init).thenAnswer((_) async {});
      when(mockDependency.inject).thenAnswer((_) async {});

      when(mockDependency.dispose).thenAnswer((_) async {});

      // Строим виджет
      await tester.pumpWidget(
        DependencyScope<MockDependencyContainer>(
          dependency: mockDependency,
          builder: (context) => Container(),
        ),
      );

      // Ожидаем инициализацию
      await tester.pumpAndSettle();

      verifyNever(mockDependency.dispose);

      await tester.pumpWidget(Container());

      // Проверяем, что dispose будет вызван
      verify(mockDependency.dispose).called(1);
    });

    testWidgets('re-initializes when injection changes', (tester) async {
      final mockDependency1 = MockDependencyContainer();
      final mockDependency2 = MockDependencyContainer();

      when(mockDependency1.inject).thenAnswer((_) async {});
      when(mockDependency2.inject).thenAnswer((_) async {});

      // Строим первый виджет
      await tester.pumpWidget(
        DependencyScope<MockDependencyContainer>(
          dependency: mockDependency1,
          builder: (context) => Container(),
        ),
      );

      // Завершаем первую инициализацию
      await tester.pumpAndSettle();

      // Строим новый виджет с другой зависимостью
      await tester.pumpWidget(
        DependencyScope<MockDependencyContainer>(
          dependency: mockDependency2,
          builder: (context) => Container(),
        ),
      );

      await tester.pumpAndSettle();

      // Проверяем, что инициализация новой зависимости произошла
    });
  });
}
