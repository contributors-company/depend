part of 'dependencies.dart';


typedef DependenciesLibrary = Map<Type, Dependency>;
typedef EnvironmentStore = Map<String, dynamic>;
typedef DependenciesProgress<T extends Dependency> = T Function(
    InitializationProgress progress);

abstract class Dependency {}

