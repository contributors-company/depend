import 'package:depend/depend.dart'; // Замените на фактический путь
import 'package:flutter_test/flutter_test.dart';

// Моковый класс для тестирования
class MockInjectionScopeLibrary extends Injection<MockInjectionScopeLibrary> {
  MockInjectionScopeLibrary({MockInjectionScopeLibrary? parent})
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
  group('InjectionScopeLibrary', () {
    test('Должен вернуть родителя, когда он инициализирован', () async {
      final parent = MockInjectionScopeLibrary();
      final child = MockInjectionScopeLibrary(parent: parent);
      expect(child.parent, equals(parent));
    });

    test('Должен бросить исключение, когда родитель равен null', () {
      final library = MockInjectionScopeLibrary();

      expect(() => library.parent, throwsException);
    });

    test('Метод init должен быть вызван', () async {
      final library = MockInjectionScopeLibrary();
      await library.init();

      expect(library.initCalled, isTrue);
    });
  });
}
