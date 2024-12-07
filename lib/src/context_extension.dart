import 'package:depend/depend.dart';
import 'package:flutter/widgets.dart';

/// An extension on [BuildContext] that provides convenient methods
/// for accessing dependencies registered via [DependencyProvider].
extension DependencyContext on BuildContext {
  /// Retrieves a dependency of type [T] from the nearest [DependencyProvider]
  /// in the widget tree.
  ///
  /// This method requires that a [DependencyProvider] of type [T] is present
  /// in the widget tree. If not, it will throw an error.
  ///
  /// Example:
  /// ```dart
  /// MyDependencyContainer myDependency = context.depend<MyDependencyContainer>();
  /// ```
  T depend<T extends DependencyContainer>() => DependencyProvider.of<T>(this);

  /// Retrieves a dependency of type [T] from the nearest [DependencyProvider]
  /// in the widget tree, or returns `null` if no matching [DependencyProvider]
  /// is found.
  ///
  /// This method is useful if the dependency is optional and you want to avoid
  /// throwing an error when it is not present.
  ///
  /// Example:
  /// ```dart
  /// MyDependencyContainer? myDependency = context.maybeDepend<MyDependencyContainer>();
  /// if (myDependency != null) {
  ///   // Use the dependency
  /// }
  /// ```
  T? maybeDepend<T extends DependencyContainer>() =>
      DependencyProvider.maybeOf<T>(this);
}
