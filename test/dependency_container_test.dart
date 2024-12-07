import 'package:depend/depend.dart';
import 'package:flutter_test/flutter_test.dart';

/// Тестовая реализация DependencyContainer
class TestDependencyContainer extends DependencyContainer {
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

}

void main() {
  group('DependencyContainer', () {

    test('should call dispose and set disposed to true', () {
      final container = TestDependencyContainer();

      expect(container.disposed, isFalse);

      container.dispose();

      expect(container.disposed, isTrue);
    });

  });
}
