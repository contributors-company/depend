import 'dart:async';

import 'package:depend/depend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';


class DependencyScope<T extends DependencyContainer<Object?>> extends StatefulWidget {
  const DependencyScope({
    required this.injection,
    required this.builder,
    this.placeholder,
    this.errorBuilder,
    super.key,
  });

  final T injection;
  final Widget Function(BuildContext context) builder;
  final Widget? placeholder;
  final Widget Function(Object? error)? errorBuilder;

  @override
  State<DependencyScope<T>> createState() =>
      _DependencyScopeState<T>();
}

class _DependencyScopeState<T extends DependencyContainer<Object?>>
    extends State<DependencyScope<T>> {
  late Future<void> Function() _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeInit();
  }

  @override
  void didUpdateWidget(covariant DependencyScope<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.injection != oldWidget.injection) {
      oldWidget.injection.dispose();
      _initFuture = _initializeInit();
    }
  }

  @override
  void dispose() {
    widget.injection.dispose();
    super.dispose();
  }

  Future<void> Function() _initializeInit() => widget.injection.init;

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _initFuture(),
    builder: (context, snapshot) {
      if(snapshot.hasError) {
        return widget.errorBuilder?.call(snapshot.error) ??
            ErrorWidget(snapshot.error!);
      }

      return switch(snapshot.connectionState) {
        ConnectionState.none || ConnectionState.waiting || ConnectionState.active => widget.placeholder ?? SizedBox.shrink(),
        ConnectionState.done => DependencyProvider<T>(
          injection: widget.injection,
          child: Builder(
            builder: widget.builder,
          ),
        ),
      };
    },
  );
}
