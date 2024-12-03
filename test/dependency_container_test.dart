import 'package:flutter_test/flutter_test.dart';
import 'package:depend/depend.dart';

/// Тестовая реализация DependencyContainer
class TestDependencyContainer extends DependencyContainer<TestDependencyContainer?> {
  TestDependencyContainer({super.parent});

  bool initialized = false;
  bool disposed = false;

  @override
  Future<void> init() async {
    initialized = true;
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
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

      expect(container.initialized, isFalse);

      await container.init();

      expect(container.initialized, isTrue);
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
        print(container.parent);
      } catch(err) {
        expect(err.toString(), isA<String>());
      }

      container.dispose();
    });
  });
}
