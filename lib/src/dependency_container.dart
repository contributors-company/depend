import 'package:depend/depend.dart';
import 'package:flutter/foundation.dart';

/// {@template dependencies_Injection}
/// An abstract class that serves as a foundation for managing dependencies
/// in a hierarchical and structured way.
///
/// The [DependencyContainer] class provides mechanisms for:
/// - Initializing dependencies via the [init] method.
/// - Accessing a parent dependency container for hierarchical setups.
/// - Managing the lifecycle of dependencies, including cleanup with [dispose].
///
/// ### Usage
///
/// Extend this class to create your own dependency container and implement
/// initialization and cleanup logic:
///
/// ```dart
/// class MyDependencyContainer extends DependencyContainer<void> {
///   @override
///   Future<void> init() async {
///     // Initialize your dependencies here
///   }
///
///   @override
///   void dispose() {
///     // Clean up resources
///     myStreamController.close();
///     super.dispose();
///   }
/// }
/// ```
/// {@endtemplate}
abstract class DependencyContainer<T> {
  /// Creates an instance of [DependencyContainer].
  ///
  /// - The [parent] parameter allows this container to reference another
  ///   container as its parent, enabling hierarchical dependency setups.
  DependencyContainer({T? parent}) : _parent = parent;

  final T? _parent;

  /// Provides access to the parent dependency container.
  ///
  /// Throws an [InjectionException] if the parent is not set or initialized.
  ///
  /// ### Example
  /// ```dart
  /// final parentContainer = parent;
  /// ```
  @nonVirtual
  T get parent {
    if (_parent == null) {
      throw InjectionException(
        'Parent in $runtimeType is not initialized',
        stackTrace: StackTrace.current,
      );
    }
    return _parent!;
  }

  /// Tracks whether the container's initialization logic has been executed.
  ///
  /// This ensures that the [init] method is called only once during the
  /// container's lifecycle.
  bool _isInitialization = false;

  /// Returns `true` if the container has been initialized.
  bool get isInitialization => _isInitialization;

  /// The entry point for initializing dependencies within this container.
  ///
  /// - This method should be overridden by subclasses to provide custom
  ///   initialization logic.
  /// - Ensure you call `super.init()` when overriding to maintain the
  ///   container's initialization state.
  ///
  /// ### Example
  /// ```dart
  /// @override
  /// Future<void> init() async {
  ///   await super.init();
  ///   // Custom initialization logic
  ///   someDependency = await initializeDependency();
  /// }
  /// ```
  @mustCallSuper
  Future<void> init();

  /// A wrapper method that ensures [init] is called only once.
  ///
  /// This method checks if the container is already initialized and skips
  /// the initialization if it is.
  ///
  /// ### Example
  /// ```dart
  /// await dependencyContainer.inject();
  /// ```
  Future<void> inject() async {
    if (_isInitialization) return;
    _isInitialization = true;
    await init();
  }

  /// Cleans up resources or dependencies managed by this container.
  ///
  /// Override this method to perform any necessary cleanup, such as closing
  /// streams, canceling timers, or disposing objects.
  ///
  /// The base implementation does nothing, so overriding this method is
  /// optional unless cleanup is required.
  ///
  /// ### Example
  /// ```dart
  /// @override
  /// void dispose() {
  ///   myStreamController.close();
  ///   super.dispose();
  /// }
  /// ```
  void dispose() {}
}
