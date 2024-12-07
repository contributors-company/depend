import 'package:depend/depend.dart';

/// An abstract class representing a factory responsible for creating instances of a specific
/// type of [DependencyContainer].
///
/// The [DependencyFactory] is designed to define a blueprint for creating dependency containers,
/// which are typically used for managing application dependencies in a structured and reusable way.
///
/// Type Parameter:
/// - [T]: A subtype of [DependencyContainer], ensuring that only valid dependency containers
///   are created by this factory.
///
/// Usage:
/// - Extend this class and implement the [create] method to define how to construct
///   the specific dependency container.
///
/// Example:
/// ```dart
/// class MyDependencyContainer extends DependencyContainer {
///   final String value;
///   MyDependencyContainer(this.value);
/// }
///
/// class MyDependencyFactory extends DependencyFactory<MyDependencyContainer> {
///   @override
///   Future<MyDependencyContainer> create() async {
///     return MyDependencyContainer('Initialized Dependency');
///   }
/// }
///
/// void main() async {
///   final factory = MyDependencyFactory();
///   final container = await factory.create();
///   print(container.value); // Outputs: Initialized Dependency
/// }
/// ```
abstract class DependencyFactory<T extends DependencyContainer> {
  /// Asynchronously creates an instance of the dependency container.
  ///
  /// This method must be implemented by concrete subclasses to define the logic
  /// for constructing the dependency container. This could include any initialization,
  /// such as creating services, loading configurations, or establishing connections.
  ///
  /// Returns:
  /// - A [Future] that resolves to an instance of [T], the concrete dependency container.
  Future<T> create();
}
