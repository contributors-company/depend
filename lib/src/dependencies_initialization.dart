part of 'dependencies.dart';

/// The `DependenciesInit` class is responsible for initializing the
/// dependencies and the environment store.
class DependenciesInit {
  /// The dependencies library.
  final DependenciesLibrary dependencies = {};

  /// The environment store.
  final EnvironmentStore? environmentStore;

  /// Initialize the dependencies.
  DependenciesInit({
    this.environmentStore,
    required List<DependenciesProgress> progress,
  }) {
    for (final progress in progress) {
      final stopWatch = Stopwatch()..start();

      final dependency = progress(InitializationProgress(
        dependencies: dependencies,
        environmentStore: environmentStore ?? {},
      ));

      dependencies.addAll({
        dependency.runtimeType: dependency,
      });

      stopWatch.stop();

      debugPrint(
          '💡 ${dependency.runtimeType}: initialized successfully for ${stopWatch.elapsedMilliseconds} ms');
    }
  }
}
