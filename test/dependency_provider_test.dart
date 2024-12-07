import 'package:depend/depend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Мок зависимости
class MockDependencyContainer extends DependencyContainer {
  MockDependencyContainer(this.value);

  String value;
}

class MockDependencyFactory extends DependencyFactory<MockDependencyContainer> {
  MockDependencyFactory({this.value = 'Value'});

  final String value;

  @override
  Future<MockDependencyContainer> create() async =>
      MockDependencyContainer(value);
}

void main() {
  group('DependencyScope Tests', () {
    testWidgets('retrieves dependency correctly', (tester) async {
      // Создание контейнера с зависимостью
      final factory = MockDependencyFactory(value: 'Test Dependency');
      final dependency = await factory.create();
      final k1 = GlobalKey();
      final mkey = GlobalKey();

      // Строим виджет с DependencyScope
      await tester.pumpWidget(
        MaterialApp(
          key: mkey,
          home: DependencyProvider<MockDependencyContainer>(
              dependency: dependency,
              child: Builder(
                builder: (context) {
                  final dependency =
                      DependencyProvider.of<MockDependencyContainer>(context);
                  return Text(key: k1, dependency.value);
                },
              )),
        ),
      );

      await tester.pumpAndSettle();

      // Проверяем, что текст "Test Dependency" отображается
      expect(find.text('Test Dependency'), findsOneWidget);
      expect(k1.currentContext!.depend<MockDependencyContainer>(), dependency);
      expect(
          mkey.currentContext?.maybeDepend<MockDependencyContainer>(), isNull);
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
              } catch (error) {
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

    testWidgets('maybeOf returns null when dependency is not found',
        (tester) async {
      // Строим виджет без DependencyScope
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Пытаемся получить зависимость через maybeOf, и она должна вернуть null
              final dependency =
                  DependencyProvider.maybeOf<MockDependencyContainer>(context);
              return Text(dependency?.value ?? 'No dependency');
            },
          ),
        ),
      );

      // Проверяем, что в тексте будет "No dependency"
      expect(find.text('No dependency'), findsOneWidget);
    });

    testWidgets('updateShouldNotify returns true if dependency changes',
        (tester) async {
      final factory1 = MockDependencyFactory(value: 'Dependency 1');
      final factory2 = MockDependencyFactory(value: 'Dependency 2');

      // Строим виджет с DependencyScope
      final mockDependency1 = await factory1.create();
      final mockDependency2 = await factory2.create();

      var a = true;

      // Создаём StatefulWidget для теста обновления
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) =>
                DependencyProvider<MockDependencyContainer>(
              dependency: a ? mockDependency1 : mockDependency2,
              child: Builder(
                builder: (context) {
                  final dependency =
                      DependencyProvider.of<MockDependencyContainer>(context, listen: true);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        a = !a;
                      });
                    },
                    child: Text(dependency.value), // Текущая зависимость
                  );
                },
              ),
            ),
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
