part of 'dependencies.dart';

/// The `InitializationProgress` class is responsible for initializing the
/// dependencies and the environment store.
class InitializationProgress {
  /// The dependencies library.
  final DependenciesLibrary dependencies;

  /// The environment store.
  final EnvironmentStore environmentStore;

  InitializationProgress({
    required this.dependencies,
    this.environmentStore = const {},
  });
}
