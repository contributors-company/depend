import 'package:depend/depend.dart';
import 'package:flutter/widgets.dart';

/// A widget that initializes and provides a [DependencyContainer] to its subtree.
///
/// [DependencyScope] manages the lifecycle of the dependency by:
/// - Initializing it using the `factory`'s [DependencyFactory.create] method.
/// - Disposing of it when it is no longer needed or replaced.
///
/// This widget is useful for scoping dependencies to a specific portion of the widget tree.
///
/// ### Example
///
/// ```dart
/// DependencyScope<MyDependency, MyDependencyFactory>(
///   factory: MyDependencyFactory(),
///   placeholder: CircularProgressIndicator(),
///   errorBuilder: (error) => Text('Error: $error'),
///   builder: (context) {
///     final dependency = DependencyProvider.of<MyDependency>(context);
///     return MyWidget(dependency: dependency);
///   },
/// );
/// ```
class DependencyScope<T extends DependencyContainer,
    F extends DependencyFactory<T>> extends StatefulWidget {
  /// Creates a [DependencyScope] widget.
  ///
  /// - The [factory] parameter specifies a [DependencyFactory] that will be used
  ///   to asynchronously create the [DependencyContainer] instance.
  /// - The [builder] parameter is a function that builds the widget tree once
  ///   the dependency has been initialized.
  /// - The optional [placeholder] is displayed while the dependency is being
  ///   initialized.
  /// - The optional [errorBuilder] is called if an error occurs during
  ///   initialization.
  const DependencyScope({
    required this.factory,
    required this.builder,
    this.placeholder,
    this.errorBuilder,
    super.key,
  });

  /// A factory that provides the logic to create the dependency asynchronously.
  ///
  /// This factory allows the [DependencyScope] to initialize the [DependencyContainer]
  /// dynamically. If the [factory] changes during the widget's lifecycle, the
  /// old dependency will be disposed, and a new one will be created.
  ///
  /// Example:
  /// ```dart
  /// class MyDependencyFactory extends DependencyFactory<MyDependency> {
  ///   @override
  ///   Future<MyDependency> create() async {
  ///     return MyDependency(await fetchConfig());
  ///   }
  /// }
  /// ```
  final F factory;

  /// A builder function that constructs the widget tree once the dependency
  /// has been initialized.
  final Widget Function(BuildContext context) builder;

  /// A widget to display while the dependency is being initialized.
  final Widget? placeholder;

  /// A builder function to construct a widget if an error occurs during
  /// dependency initialization.
  final Widget Function(Object? error)? errorBuilder;

  @override
  State<DependencyScope<T, F>> createState() => _DependencyScopeState<T, F>();
}

class _DependencyScopeState<T extends DependencyContainer,
    F extends DependencyFactory<T>> extends State<DependencyScope<T, F>> {
  T? _dependency;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DependencyScope<T, F> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Dispose of the old dependency and initialize the new one if it has changed.
    if (widget.factory != oldWidget.factory) {
      _dependency?.dispose.call();
    }
  }

  @override
  void dispose() {
    // Dispose of the managed dependency when the widget is removed from the tree.
    _dependency?.dispose.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
        future: Future.value(widget.factory.create()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Display the error widget if an error occurs during initialization.
            return widget.errorBuilder?.call(snapshot.error) ??
                ErrorWidget(snapshot.error!);
          }

          if (snapshot.hasData) {
            _dependency = snapshot.requireData;
          }

          return switch (snapshot.connectionState) {
            // Show the placeholder while waiting for the dependency to initialize.
            ConnectionState.none ||
            ConnectionState.waiting ||
            ConnectionState.active =>
              widget.placeholder ?? const SizedBox.shrink(),

            // Provide the dependency once initialization is complete.
            ConnectionState.done => DependencyProvider<T>(
                dependency: snapshot.requireData,
                child: Builder(
                  builder: widget.builder,
                ),
              ),
          };
        },
      );
}
