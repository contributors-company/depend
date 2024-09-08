import 'package:flutter/cupertino.dart';

part 'types.dart';
part 'dependencies_initialization.dart';
part 'extensions.dart';
part 'initialization_progress.dart';

class Dependencies extends InheritedWidget {
  final DependenciesLibrary _dependencies;

  const Dependencies({
    super.key,
    required super.child,
    required DependenciesLibrary dependencies,
  }) : _dependencies = dependencies;

  T get<T extends Dependency>() {
    return _dependencies[T] as T;
  }

  static Dependencies of(BuildContext context) {
    final dependencies =
    context.dependOnInheritedWidgetOfExactType<Dependencies>();
    if (dependencies == null) {
      throw FlutterError('Dependencies widget not found in the widget tree');
    }
    return dependencies;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
