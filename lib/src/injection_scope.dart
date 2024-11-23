import 'dart:async';

import 'package:depend/depend.dart';
import 'package:flutter/widgets.dart';

/// {@template dependencies_class}
/// An `InheritedWidget` that provides access to a [Injection]
/// instance throughout the widget tree.
///
/// The `InjectionScope` widget initializes the provided [injection] and ensures
/// it's available to all descendant widgets. It handles asynchronous
/// initialization and can display a [placeholder] widget while the [injection]
/// is being initialized.
///
/// ### Example
///
/// ```dart
/// class MyInjection extends Injection<void> {
///   @override
///   Future<void> init() async {
///     // Initialize your dependencies here
///   }
/// }
///
/// void main() {
///   runApp(
///     InjectionScope<MyInjection>(
///       injection: MyInjection(),
///       placeholder: CircularProgressIndicator(),
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
/// {@endtemplate}
class InjectionScope<T extends Injection<Object?>> extends InheritedWidget {
  /// {@macro dependencies_class}
  ///
  /// Creates a [InjectionScope] widget.
  ///
  /// The [injection] parameter must not be null and is the [Injection]
  /// instance that will be provided to descendants.
  ///
  /// The [child] parameter is the widget below this widget in the tree.
  ///
  /// The [placeholder] widget is displayed while the [injection] is initializing.
  /// If [placeholder] is not provided, [child] is displayed immediately.
  InjectionScope({
    required this.injection,
    required super.child,
    super.key,
    this.placeholder,
  }) {
    injection.init().then((val) {
      completer.complete(injection);
    }).catchError((Object error) {
      completer.completeError(error, StackTrace.current);
    });
  }

  /// A [Completer] to handle the asynchronous initialization of the [injection].
  final Completer<T> completer = Completer<T>();

  /// The instance of [Injection] to provide to the widget tree.
  final T injection;

  /// An optional widget to display while the [injection] is initializing.
  final Widget? placeholder;

  /// {@template dependencies_maybe_of}
  /// Provides the nearest [Injection] of type [T] up the widget tree.
  ///
  /// Returns `null` if no such [InjectionScope] is found.
  ///
  /// The [listen] parameter determines whether the context will rebuild when
  /// the [InjectionScope] updates. If [listen] is `true`, the context will
  /// subscribe to changes; otherwise, it will not.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final injection = InjectionScope.maybeOf<MyInjection>(context);
  /// if (injection != null) {
  ///   // Use the injection
  /// }
  /// ```
  /// {@endtemplate}
  static T? maybeOf<T extends Injection<Object?>>(
    BuildContext context, {
    bool listen = false,
  }) =>
      listen
          ? context
              .dependOnInheritedWidgetOfExactType<InjectionScope<T>>()
              ?.injection
          : context
              .getInheritedWidgetOfExactType<InjectionScope<T>>()
              ?.injection;

  /// {@template dependencies_of}
  /// Provides the nearest [Injection] of type [T] up the widget tree.
  ///
  /// Throws an [ArgumentError] if no such [InjectionScope] is found.
  ///
  /// The [listen] parameter determines whether the context will rebuild when
  /// the [InjectionScope] updates. If [listen] is `true`, the context will
  /// subscribe to changes; otherwise, it will not.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final injection = InjectionScope.of<MyInjection>(context);
  /// // Use the injection
  /// ```
  /// {@endtemplate}
  static T of<T extends Injection<Object?>>(
    BuildContext context, {
    bool listen = false,
  }) =>
      maybeOf<T>(context, listen: listen) ?? _notFound<T>();

  static Never _notFound<T extends Injection<Object?>>() => throw ArgumentError(
      'InjectionScope.of<$T>() called with a context that does not contain an $T.');

  @override
  Widget get child => FutureBuilder<T>(
        future: completer.future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }
          return switch (snapshot.connectionState) {
            ConnectionState.none ||
            ConnectionState.waiting ||
            ConnectionState.active =>
              placeholder ?? super.child,
            ConnectionState.done => _DisposeDependency<T>(
                injection: injection,
                child: super.child,
              )
          };
        },
      );

  @override
  bool updateShouldNotify(InjectionScope oldWidget) =>
      injection != oldWidget.injection;
}

class _DisposeDependency<T extends Injection<Object?>> extends StatefulWidget {
  const _DisposeDependency({
    required this.child,
    required this.injection,
    super.key,
  });

  final T injection;
  final Widget child;

  @override
  State<_DisposeDependency> createState() => _DisposeDependencyState();
}

class _DisposeDependencyState<T extends Injection<Object?>>
    extends State<_DisposeDependency<T>> {
  @override
  void dispose() {
    widget.injection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
