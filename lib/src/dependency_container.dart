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
abstract class DependencyContainer {
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
