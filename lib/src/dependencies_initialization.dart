part of 'dependencies.dart';

class DependenciesInit {
  final DependenciesLibrary dependencies = {};
  final EnvironmentStore? environmentStore;

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
