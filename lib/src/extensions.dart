part of 'dependencies.dart';

extension DependenciesLibraryExt on DependenciesLibrary {
  T get<T extends Dependency>() {
    return this[T] as T;
  }
}
