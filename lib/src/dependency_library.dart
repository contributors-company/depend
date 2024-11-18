import 'package:flutter/foundation.dart';

/// {@template dependencies_library}
/// An abstract class that serves as a base for managing dependencies in your application.
/// It provides a structure for initializing dependencies and accessing a parent library if needed.
///
/// The `DependenciesLibrary` class is designed to be extended by your own dependency library classes,
/// allowing you to define initialization logic and manage dependencies effectively.
///
/// ### Example
///
/// ```dart
/// class MyDependencies extends DependenciesLibrary<void> {
///   @override
///   Future<void> init() async {
///     // Initialize your dependencies here
///     await log(() async {
///       // Initialize a specific dependency
///       return await initializeMyDependency();
///     });
///   }
/// }
/// ```
/// {@endtemplate}
abstract class DependenciesLibrary<T> {
  /// Creates a new instance of [DependenciesLibrary].
  ///
  /// The optional [parent] parameter allows you to reference a parent dependencies library,
  /// enabling hierarchical dependency management.
  DependenciesLibrary({T? parent}) : _parent = parent;

  final T? _parent;

  /// Provides access to the parent dependencies library.
  ///
  /// Throws an [Exception] if the parent is not initialized.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final parentLibrary = parent;
  /// ```
  @nonVirtual
  T get parent {
    if (_parent == null) {
      throw Exception('Parent in $runtimeType is not initialized');
    }
    return _parent!;
  }

  /// Initializes the dependencies.
  ///
  /// This method should be overridden in subclasses to implement the initialization logic
  /// for your dependencies. The `@mustCallSuper` annotation indicates that if you override
  /// this method, you should call `super.init()` to ensure proper initialization.
  ///
  /// ### Example
  ///
  /// ```dart
  /// @override
  /// Future<void> init() async {
  ///   await super.init();
  ///   // Your initialization code here
  /// }
  /// ```
  @mustCallSuper
  Future<void> init();
  // coverage:ignore-start

  /// Cleans up resources used by the dependencies.
  ///
  /// This method can be overridden to release any resources, close streams, or dispose
  /// of objects that were initialized in the `init` method or elsewhere in the library.
  ///
  /// The base implementation is empty, so calling `super.dispose()` is optional unless
  /// overridden by subclasses to include specific cleanup logic.
  ///
  /// ### Example
  ///
  /// ```dart
  /// @override
  /// void dispose() {
  ///   // Close a stream controller
  ///   myStreamController.close();
  ///
  ///   // Dispose of other resources
  ///   someDependency.dispose();
  ///
  ///   super.dispose();
  /// }
  /// ```
  void dispose() {}

  /// Logs the initialization process of a dependency.
  ///
  /// This method executes the provided [callback] and logs the time taken to complete it.
  /// In release mode, the [callback] is executed without logging to avoid performance overhead.
  /// In debug mode, it measures the execution time and prints it using `debugPrint`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// await log(() async {
  ///   return await initializeMyDependency();
  /// });
  /// ```
  @nonVirtual
  Future<void> log(Future<Object?> Function() callback) async {
    if (kReleaseMode) {
      await callback();
    } else if (kDebugMode) {
      final stopWatch = Stopwatch()..start();
      final result = await callback();
      stopWatch.stop();
      debugPrint(
        '💡${result.runtimeType} initialized successfully in ${stopWatch.elapsedMilliseconds} ms',
      );
    }
  }
// coverage:ignore-end
}
