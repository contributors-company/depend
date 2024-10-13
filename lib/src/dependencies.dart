import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

part 'types.dart';
part 'dependencies_initialization.dart';
part 'extensions.dart';
part 'initialization_progress.dart';

/// The `Dependencies` class is an `InheritedWidget` that provides access to
/// a `DependenciesLibrary` instance throughout the widget tree.
class Dependencies extends InheritedWidget {
  final DependenciesLibrary dependencies;

  const Dependencies({
    super.key,
    required this.dependencies,
    required super.child,
  });

  static DependenciesLibrary of(BuildContext context) {
    final Dependencies? result =
        context.getInheritedWidgetOfExactType<Dependencies>();
    assert(result != null, 'No Dependencies found in context');
    return result!.dependencies;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<DependenciesLibrary>('dependencies', dependencies),
    );
  }

  @override
  bool updateShouldNotify(Dependencies oldWidget) => false;
}
