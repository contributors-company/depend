import 'package:depend/depend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Мок зависимости
class MockDependencyContainer extends Mock implements DependencyContainer<Object?> {
  late String value;
}

void main() {
  group('DependencyScope Tests', () {
    testWidgets('retrieves dependency correctly', (tester) async {
      // Создание контейнера с зависимостью
      final mockDependency = MockDependencyContainer();

      when(mockDependency.init).thenAnswer((_) async {
        print('asdasd');
        mockDependency.value = 'Test Dependency';
      });

      // Строим виджет с DependencyScope
      await tester.pumpWidget(
        MaterialApp(
          home: DependencyScope<MockDependencyContainer>(
            injection: mockDependency,
            builder: (context) {
              final dependency = DependencyProvider.of<MockDependencyContainer>(context);
              print(dependency.value);
              return Text(dependency.value);
            }
          ),
        ),
      );

      await tester.pumpAndSettle();


      // Проверяем, что текст "Test Dependency" отображается
      expect(find.text('Test Dependency'), findsOneWidget);
    });

    testWidgets('throws error when dependency is not found', (tester) async {



      // Строим виджет без DependencyScope
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              try {
                DependencyProvider.of<MockDependencyContainer>(context);
                return const Text('No error');
              } catch(error) {
                return ErrorWidget(error);
              }

            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Проверяем, что выброшена ошибка
      expect(find.byType(ErrorWidget), findsOneWidget);
    });

    testWidgets('maybeOf returns null when dependency is not found', (tester) async {
      // Строим виджет без DependencyScope
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Пытаемся получить зависимость через maybeOf, и она должна вернуть null
              final dependency = DependencyProvider.maybeOf<MockDependencyContainer>(context);
              return Text(dependency?.value ?? 'No dependency');
            },
          ),
        ),
      );

      // Проверяем, что в тексте будет "No dependency"
      expect(find.text('No dependency'), findsOneWidget);
    });

    testWidgets('updateShouldNotify returns true if dependency changes', (tester) async {
      // Строим виджет с DependencyScope
      final mockDependency1 = MockDependencyContainer();
      final mockDependency2 = MockDependencyContainer();

      when(mockDependency1.init).thenAnswer((_) async {
        mockDependency1.value = 'Dependency 1';
      });
      when(mockDependency2.init).thenAnswer((_) async {
        mockDependency2.value = 'Dependency 2';
      });

      bool a = true;

      // Создаём StatefulWidget для теста обновления
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return DependencyScope<MockDependencyContainer>(
                injection: a ? mockDependency1 : mockDependency2,
                builder: (context) {
                  final dependency = DependencyProvider.of<MockDependencyContainer>(context, listen: true);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        a = !a;
                      });
                    },
                    child: Text(dependency.value), // Текущая зависимость
                  );
                },
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();


      // Проверяем начальное значение
      expect(find.text('Dependency 1'), findsOneWidget);

      await tester.tap(find.text('Dependency 1'));
      await tester.pumpAndSettle();

      // Проверяем, что зависимость изменилась
      expect(find.text('Dependency 2'), findsOneWidget);
    });

  });

}
