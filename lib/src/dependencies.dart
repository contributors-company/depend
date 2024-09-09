import 'package:flutter/cupertino.dart';

part 'types.dart';
part 'dependencies_initialization.dart';
part 'extensions.dart';
part 'initialization_progress.dart';

/// The `Dependencies` class is an `InheritedWidget` that provides access to
/// a `DependenciesLibrary` instance throughout the widget tree.
class Dependencies extends InheritedWidget {
  final DependenciesLibrary _dependencies;

  const Dependencies({
    super.key,
    required super.child,
    required DependenciesLibrary dependencies,
  }) : _dependencies = dependencies;

  /// Retrieves a dependency of type `T` from the `DependenciesLibrary`.
  ///
  /// Throws a `TypeError` if the dependency is not found.
  T get<T extends Dependency>() {
    return _dependencies[T] as T;
  }

  /// Retrieves the `Dependencies` instance from the given `BuildContext`.
  ///
  /// Throws a `FlutterError` if the `Dependencies` widget is not found in the
  /// widget tree.
  static Dependencies of(BuildContext context) {
    final dependencies =
        context.dependOnInheritedWidgetOfExactType<Dependencies>();
    if (dependencies == null) {
      throw FlutterError('Dependencies widget not found in the widget tree');
    }
    return dependencies;
  }

  /// Determines whether the widget should notify its dependents when it is
  /// rebuilt.
  ///
  /// Always returns `false` in this implementation.
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
