part of 'dependencies.dart';

/// The `DependenciesLibrary` class is a map of dependencies that can be
/// accessed by type.
typedef DependenciesLibrary = Map<Type, Dependency>;

/// The `EnvironmentStore` class is a map of environment variables that can be
/// accessed by name.
typedef EnvironmentStore = Map<String, dynamic>;

/// The `DependenciesProgress` class is responsible for initializing the
/// dependencies and the environment store.
typedef DependenciesProgress<T extends Dependency> = Future<T> Function(
    InitializationProgress progress);

/// The `Dependency` class is a base class for all dependencies.
abstract class Dependency {}
