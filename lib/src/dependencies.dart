import 'dart:async';

import 'package:depend/depend.dart';
import 'package:flutter/widgets.dart';

/// {@template dependencies_class}
/// An `InheritedWidget` that provides access to a [DependenciesLibrary]
/// instance throughout the widget tree.
///
/// The `Dependencies` widget initializes the provided [library] and ensures
/// it's available to all descendant widgets. It handles asynchronous
/// initialization and can display a [placeholder] widget while the [library]
/// is being initialized.
///
/// ### Example
///
/// ```dart
/// class MyDependenciesLibrary extends DependenciesLibrary<void> {
///   @override
///   Future<void> init() async {
///     // Initialize your dependencies here
///   }
/// }
///
/// void main() {
///   runApp(
///     Dependencies<MyDependenciesLibrary>(
///       library: MyDependenciesLibrary(),
///       placeholder: CircularProgressIndicator(),
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
/// {@endtemplate}
class Dependencies<T extends DependenciesLibrary<Object?>>
    extends InheritedWidget {
  /// {@macro dependencies_class}
  ///
  /// Creates a [Dependencies] widget.
  ///
  /// The [library] parameter must not be null and is the [DependenciesLibrary]
  /// instance that will be provided to descendants.
  ///
  /// The [child] parameter is the widget below this widget in the tree.
  ///
  /// The [placeholder] widget is displayed while the [library] is initializing.
  /// If [placeholder] is not provided, [child] is displayed immediately.
  Dependencies({
    required this.library,
    required super.child,
    super.key,
    this.placeholder,
  }) {
    library.init().then((val) {
      completer.complete(library);
    }).catchError((Object error) {
      completer.completeError(error, StackTrace.current);
    });
  }

  /// A [Completer] to handle the asynchronous initialization of the [library].
  final Completer<T> completer = Completer<T>();

  /// The instance of [DependenciesLibrary] to provide to the widget tree.
  final T library;

  /// An optional widget to display while the [library] is initializing.
  final Widget? placeholder;

  /// {@template dependencies_maybe_of}
  /// Provides the nearest [DependenciesLibrary] of type [T] up the widget tree.
  ///
  /// Returns `null` if no such [Dependencies] is found.
  ///
  /// The [listen] parameter determines whether the context will rebuild when
  /// the [Dependencies] updates. If [listen] is `true`, the context will
  /// subscribe to changes; otherwise, it will not.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final library = Dependencies.maybeOf<MyDependenciesLibrary>(context);
  /// if (library != null) {
  ///   // Use the library
  /// }
  /// ```
  /// {@endtemplate}
  static T? maybeOf<T extends DependenciesLibrary<Object?>>(
    BuildContext context, {
    bool listen = false,
  }) =>
      listen
          ? context
              .dependOnInheritedWidgetOfExactType<Dependencies<T>>()
              ?.library
          : context.getInheritedWidgetOfExactType<Dependencies<T>>()?.library;

  /// {@template dependencies_of}
  /// Provides the nearest [DependenciesLibrary] of type [T] up the widget tree.
  ///
  /// Throws an [ArgumentError] if no such [Dependencies] is found.
  ///
  /// The [listen] parameter determines whether the context will rebuild when
  /// the [Dependencies] updates. If [listen] is `true`, the context will
  /// subscribe to changes; otherwise, it will not.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final library = Dependencies.of<MyDependenciesLibrary>(context);
  /// // Use the library
  /// ```
  /// {@endtemplate}
  static T of<T extends DependenciesLibrary<Object?>>(
    BuildContext context, {
    bool listen = false,
  }) =>
      maybeOf<T>(context, listen: listen) ?? _notFound<T>();

  static Never _notFound<T extends DependenciesLibrary<Object?>>() =>
      throw ArgumentError(
          'Dependencies.of<$T>() called with a context that does not contain an $T.');

  @override
  Widget get child => FutureBuilder<T>(
        future: completer.future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return placeholder ??
                  _DisposeDependency<T>(
                    library: library,
                    child: super.child,
                  );
            case ConnectionState.done:
              return _DisposeDependency<T>(
                library: library,
                child: super.child,
              );
          }
        },
      );

  @override
  bool updateShouldNotify(Dependencies oldWidget) =>
      library != oldWidget.library;
}

class _DisposeDependency<T extends DependenciesLibrary<Object?>>
    extends StatefulWidget {
  const _DisposeDependency(
      {required this.child, required this.library, super.key});

  final T library;
  final Widget child;

  @override
  State<_DisposeDependency> createState() => _DisposeDependencyState();
}

class _DisposeDependencyState<T extends DependenciesLibrary<Object?>>
    extends State<_DisposeDependency<T>> {
  @override
  void dispose() {
    super.dispose();
    widget.library.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
