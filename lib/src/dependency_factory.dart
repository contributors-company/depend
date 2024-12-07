import 'package:depend/depend.dart';

abstract class DependencyFactory<T extends DependencyContainer> {
  Future<T> create();
}
