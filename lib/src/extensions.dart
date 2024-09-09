part of 'dependencies.dart';

/// The `DependenciesLibrary` class is a map of dependencies that can be
/// accessed by type.
extension DependenciesLibraryExt on DependenciesLibrary {
  /// Retrieves a dependency of type `T` from the `DependenciesLibrary`.
  T get<T extends Dependency>() {
    return this[T] as T;
  }
}
