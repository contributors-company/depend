import 'package:depend/depend.dart';
import 'package:flutter/widgets.dart';

/// A widget that provides a [DependencyContainer] (or its subclass) to its subtree.
///
/// [DependencyProvider] acts as a bridge to pass dependencies down the widget
/// tree. It allows widgets to access the provided dependency using the static
/// [of] or [maybeOf] methods.
///
/// ### Usage
///
/// ```dart
/// DependencyProvider<MyDependency>(
///   injection: MyDependency(),
///   child: MyApp(),
/// );
/// ```
///
/// Widgets in the subtree can access the dependency as follows:
///
/// ```dart
/// final myDependency = DependencyProvider.of<MyDependency>(context);
/// ```
class DependencyProvider<T extends DependencyContainer>
    extends InheritedWidget {
  /// Creates a [DependencyProvider] widget.
  ///
  /// - The [dependency] parameter is the dependency instance to provide to
  ///   the widget tree. It must not be `null`.
  /// - Either [builder] or [child] must be provided:
  ///   - [builder]: A function that returns the child widget. This is useful
  ///     when the child requires access to the dependency during its creation.
  ///   - [child]: The widget below this widget in the tree.
  DependencyProvider({
    required this.dependency,
    super.key,
    Widget Function()? builder,
    Widget? child,
  }) : super(child: child ?? builder?.call() ?? const Offstage());

  /// The dependency instance being provided to the subtree.
  final T dependency;

  /// Provides the nearest [DependencyContainer] of type [T] from the widget tree.
  ///
  /// This method returns `null` if no [DependencyProvider] of the specified
  /// type is found.
  ///
  /// - The [listen] parameter determines whether the widget should rebuild
  ///   when the [DependencyProvider] updates:
  ///   - If `true`, the context will subscribe to changes and rebuild when
  ///     the dependency updates.
  ///   - If `false`, the context will not rebuild when the dependency changes.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final myDependency = DependencyProvider.maybeOf<MyDependency>(context);
  /// if (myDependency != null) {
  ///   // Use the dependency
  /// }
  /// ```
  static T? maybeOf<T extends DependencyContainer>(
    BuildContext context, {
    bool listen = false,
  }) =>
      listen
          ? context
              .dependOnInheritedWidgetOfExactType<DependencyProvider<T>>()
              ?.dependency
          : context
              .getInheritedWidgetOfExactType<DependencyProvider<T>>()
              ?.dependency;

  /// Provides the nearest [DependencyContainer] of type [T] from the widget tree.
  ///
  /// This method throws an [ArgumentError] if no [DependencyProvider] of the
  /// specified type is found.
  ///
  /// - The [listen] parameter determines whether the widget should rebuild
  ///   when the [DependencyProvider] updates:
  ///   - If `true`, the context will subscribe to changes and rebuild when
  ///     the dependency updates.
  ///   - If `false`, the context will not rebuild when the dependency changes.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final myDependency = DependencyProvider.of<MyDependency>(context);
  /// // Use the dependency
  /// ```
  static T of<T extends DependencyContainer>(
    BuildContext context, {
    bool listen = false,
  }) =>
      maybeOf<T>(context, listen: listen) ?? _notFound<T>();

  /// Helper method to throw an error when a dependency of type [T] is not found.
  static Never _notFound<T extends DependencyContainer>() => throw ArgumentError(
      'DependencyProvider.of<$T>() called with a context that does not contain an $T.');

  /// Determines whether widgets that depend on this [DependencyProvider] should rebuild.
  ///
  /// Returns `true` if the provided [dependency] has changed since the last
  /// build, and `false` otherwise.
  ///
  /// This is used by the Flutter framework to optimize widget rebuilding.
  @override
  bool updateShouldNotify(DependencyProvider oldWidget) =>
      dependency != oldWidget.dependency;
}
