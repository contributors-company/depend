import 'package:depend/depend.dart';
import 'package:flutter_test/flutter_test.dart';

/// Тестовая реализация DependencyContainer
class TestDependencyContainer
    extends DependencyContainer<TestDependencyContainer?> {
  TestDependencyContainer({super.parent});
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Future<void> init() async {}
}

void main() {
  group('DependencyContainer', () {
    test('should provide access to parent if initialized', () {
      final parentContainer = TestDependencyContainer();
      final childContainer = TestDependencyContainer(parent: parentContainer);

      expect(childContainer.parent, equals(parentContainer));
    });

    test('should throw InjectionException if parent is not initialized', () {
      final container = TestDependencyContainer();

      expect(() => container.parent, throwsA(isA<InjectionException>()));
    });

    test('should call init and set initialized to true', () async {
      final container = TestDependencyContainer();

      expect(container.isInitialization, isFalse);

      await container.inject();

      expect(container.isInitialization, isTrue);
    });

    test('should call dispose and set disposed to true', () {
      final container = TestDependencyContainer();

      expect(container.disposed, isFalse);

      container.dispose();

      expect(container.disposed, isTrue);
    });

    test('take parent then parent null', () {
      final container = TestDependencyContainer();

      expect(() => container.parent, throwsA(isA<InjectionException>()));
      try {
        container.parent;
      } catch (err) {
        expect(err.toString(), isA<String>());
      }

      container.dispose();
    });

    test('isInitialization', () async {
      final container = TestDependencyContainer();

      expect(container.isInitialization, isFalse);

      await container.inject();

      expect(container.isInitialization, isTrue);

      await container.inject();

      expect(container.isInitialization, isTrue);

      container.dispose();
    });
  });
}
