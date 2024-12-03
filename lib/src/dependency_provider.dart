import 'package:depend/depend.dart';
import 'package:flutter/widgets.dart';

class DependencyProvider<T extends DependencyContainer<Object?>> extends InheritedWidget {
  /// {@macro dependencies_class}
  ///
  /// Creates a [DependencyProvider] widget.
  ///
  /// The [injection] parameter must not be null and is the [Injection]
  /// instance that will be provided to descendants.
  ///
  /// The [child] parameter is the widget below this widget in the tree.
  ///
  /// The [placeholder] widget is displayed while the [injection] is initializing.
  /// If [placeholder] is not provided, [child] is displayed immediately.
  DependencyProvider({
    required this.injection,
    required super.child,
    super.key,
    this.placeholder,
  });

  /// The instance of [Injection] to provide to the widget tree.
  final T injection;

  /// An optional widget to display while the [injection] is initializing.
  final Widget? placeholder;

  /// {@template dependencies_maybe_of}
  /// Provides the nearest [Injection] of type [T] up the widget tree.
  ///
  /// Returns `null` if no such [DependencyProvider] is found.
  ///
  /// The [listen] parameter determines whether the context will rebuild when
  /// the [DependencyProvider] updates. If [listen] is `true`, the context will
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
  static T? maybeOf<T extends DependencyContainer<Object?>>(
      BuildContext context, {
        bool listen = false,
      }) =>
      listen
          ? context
          .dependOnInheritedWidgetOfExactType<DependencyProvider<T>>()
          ?.injection
          : context
          .getInheritedWidgetOfExactType<DependencyProvider<T>>()
          ?.injection;

  /// {@template dependencies_of}
  /// Provides the nearest [Injection] of type [T] up the widget tree.
  ///
  /// Throws an [ArgumentError] if no such [DependencyProvider] is found.
  ///
  /// The [listen] parameter determines whether the context will rebuild when
  /// the [DependencyProvider] updates. If [listen] is `true`, the context will
  /// subscribe to changes; otherwise, it will not.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final injection = InjectionScope.of<MyInjection>(context);
  /// // Use the injection
  /// ```
  /// {@endtemplate}
  static T of<T extends DependencyContainer<Object?>>(
      BuildContext context, {
        bool listen = false,
      }) =>
      maybeOf<T>(context, listen: listen) ?? _notFound<T>();

  static Never _notFound<T extends DependencyContainer<Object?>>() => throw ArgumentError(
      'InjectionScope.of<$T>() called with a context that does not contain an $T.');


  @override
  bool updateShouldNotify(DependencyProvider oldWidget) =>
      injection != oldWidget.injection;
}
