import 'package:depend/depend.dart'; // Замените на фактический путь
import 'package:flutter_test/flutter_test.dart';

// Моковый класс для тестирования
class MockDependenciesLibrary
    extends DependenciesLibrary<MockDependenciesLibrary> {
  MockDependenciesLibrary({MockDependenciesLibrary? parent})
      : super(parent: parent);
  bool initCalled = false;

  @override
  Future<void> init() async {
    initCalled = true;
    // Имитируем инициализацию
    await Future.delayed(const Duration(milliseconds: 100), () => 1);
  }
}

void main() {
  group('DependenciesLibrary', () {
    test('Должен вернуть родителя, когда он инициализирован', () async {
      final parent = MockDependenciesLibrary();
      final child = MockDependenciesLibrary(parent: parent);
      expect(child.parent, equals(parent));
    });

    test('Должен бросить исключение, когда родитель равен null', () {
      final library = MockDependenciesLibrary();

      expect(() => library.parent, throwsException);
    });

    test('Метод init должен быть вызван', () async {
      final library = MockDependenciesLibrary();
      await library.init();
      await library.log(() async {
        await Future.delayed(const Duration(milliseconds: 100), () => 1);
        return null;
      });

      expect(library.initCalled, isTrue);
    });
  });
}
