part of 'dependencies.dart';

class InitializationProgress {
  final DependenciesLibrary dependencies;
  final EnvironmentStore environmentStore;

  InitializationProgress({
    required this.dependencies,
    this.environmentStore = const {},
  });
}
