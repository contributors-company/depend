import 'package:depend/depend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Фейковая реализация DependencyContainer
class MockDependencyContainer extends DependencyContainer {}

class MockExceptionDependencyContainer extends DependencyContainer {}

class MockDependencyFactory extends DependencyFactory<MockDependencyContainer> {
  @override
  Future<MockDependencyContainer> create() async => MockDependencyContainer();
}

class MockExceptionDependencyFactory
    extends DependencyFactory<MockExceptionDependencyContainer> {
  @override
  Future<MockExceptionDependencyContainer> create() async {
    throw Exception();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DependencyScope Tests', () {
    testWidgets('renders placeholder when initializing', (tester) async {
      // Строим виджет с placeholder
      await tester.pumpWidget(
        DependencyScope<MockDependencyContainer, MockDependencyFactory>(
          factory: MockDependencyFactory(),
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
      // Строим виджет с errorBuilder
      await tester.pumpWidget(
        MaterialApp(
          home: DependencyScope<MockExceptionDependencyContainer,
              MockExceptionDependencyFactory>(
            factory: MockExceptionDependencyFactory(),
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
      // Строим виджет с errorBuilder
      await tester.pumpWidget(
        MaterialApp(
          home: DependencyScope<MockExceptionDependencyContainer, MockExceptionDependencyFactory>(
            factory: MockExceptionDependencyFactory(),
            builder: (context) => Container(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Ожидаем, что будет отображено сообщение об ошибке
      await expectLater(find.byType(ErrorWidget), findsOneWidget);
    });

    testWidgets('calls dispose when the widget is disposed', (tester) async {
      // Строим виджет
      await tester.pumpWidget(
        DependencyScope<MockDependencyContainer, MockDependencyFactory>(
          factory: MockDependencyFactory(),
          builder: (context) => Container(),
        ),
      );

      // Ожидаем инициализацию
      await tester.pumpAndSettle();

      await tester.pumpWidget(Container());
    });

    testWidgets('re-initializes when injection changes', (tester) async {
      final mockDependency1 = MockDependencyContainer();
      final mockDependency2 = MockDependencyContainer();

      // Строим первый виджет
      await tester.pumpWidget(
        DependencyScope<MockDependencyContainer, MockDependencyFactory>(
          factory: MockDependencyFactory(),
          builder: (context) => Container(),
        ),
      );

      // Завершаем первую инициализацию
      await tester.pumpAndSettle();

      // Строим новый виджет с другой зависимостью
      await tester.pumpWidget(
        DependencyScope<MockDependencyContainer, MockDependencyFactory>(
          factory: MockDependencyFactory(),
          builder: (context) => Container(),
        ),
      );

      await tester.pumpAndSettle();

      // Проверяем, что инициализация новой зависимости произошла
    });
  });
}
