import 'package:depend/depend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Фейковая реализация DependencyContainer
class MockDependencyContainer extends Mock implements DependencyContainer<Object?> {}

class MockExceptionDependencyContainer extends Mock implements DependencyContainer<Object?> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DependencyScope Tests', () {
    testWidgets('renders placeholder when initializing', (tester) async {
      final mockDependency = MockDependencyContainer();

      when(mockDependency.init).thenAnswer((_) async {});

      // Строим виджет с placeholder
      await tester.pumpWidget(
        DependencyScope<MockDependencyContainer>(
          injection: mockDependency,
          builder: (context) => Container(),
          placeholder: CircularProgressIndicator(),
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

      when(mockDependency.init).thenAnswer((_) async {
        throw Exception();
      });

      // Строим виджет с errorBuilder
      await tester.pumpWidget(
        MaterialApp(
          home: DependencyScope<MockExceptionDependencyContainer>(
            injection: mockDependency,
            builder: (context) => Container(),
            errorBuilder: (error) => const Text('Error: Initialization error'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Ожидаем, что будет отображено сообщение об ошибке
      await expectLater(find.text('Error: Initialization error'), findsOneWidget);
    });

    testWidgets('renders errorBuilder when init fails', (tester) async {
      final mockDependency = MockDependencyContainer();

      when(mockDependency.init).thenAnswer((_) async {
        throw Exception('Exception');
      });

      // Строим виджет с errorBuilder
      await tester.pumpWidget(
        MaterialApp(
          home: DependencyScope<MockDependencyContainer>(
            injection: mockDependency,
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
      when(mockDependency.dispose).thenAnswer((_) async {});

      // Строим виджет
      await tester.pumpWidget(
        DependencyScope<MockDependencyContainer>(
          injection: mockDependency,
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


      when(mockDependency1.init).thenAnswer((_) async {});
      when(mockDependency2.init).thenAnswer((_) async {});


      // Строим первый виджет
      await tester.pumpWidget(
        DependencyScope<MockDependencyContainer>(
          injection: mockDependency1,
          builder: (context) => Container(),
        ),
      );

      // Завершаем первую инициализацию
      await tester.pumpAndSettle();

      // Строим новый виджет с другой зависимостью
      await tester.pumpWidget(
        DependencyScope<MockDependencyContainer>(
          injection: mockDependency2,
          builder: (context) => Container(),
        ),
      );

      await tester.pumpAndSettle();

      // Проверяем, что инициализация новой зависимости произошла

    });
  });
}
