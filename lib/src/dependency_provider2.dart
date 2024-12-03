import 'package:depend/depend.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class DependencyProvider<T extends DependencyContainer<Object?>> extends SingleChildStatelessWidget {
  /// {@macro dependencies_class}
  ///
  /// Creates a [DependencyProvider] widget.
  ///
  /// The [injection] parameter must not be null and is the [DependencyContainer]
  /// instance that will be provided to descendants.
  ///
  /// The [child] parameter is the widget below this widget in the tree.
  ///
  /// The [placeholder] widget is displayed while the [injection] is initializing.
  /// If [placeholder] is not provided, [child] is displayed immediately.
  const DependencyProvider({
    required this.injection,

    super.key,
    this.builder,
    bool lazy = true,
  }) : _lazy = lazy;

  /// The instance of [DependencyContainer] to provide to the widget tree.
  final T injection;
  final bool _lazy;
  final TransitionBuilder? builder;


  static T? _findInjection<T extends DependencyContainer<Object?>>(
      BuildContext context, {
        required bool listen,
        required bool throwIfNotFound,
      }) {
    try {
      return Provider.of<T>(context, listen: listen);
    } on ProviderNotFoundException catch (e) {
      if (throwIfNotFound) throw FlutterError(
        '''
        BlocProvider.of() called with a context that does not contain a $T.
        No ancestor could be found starting from the context that was passed to BlocProvider.of<$T>().

        This can happen if the context you used comes from a widget above the BlocProvider.

        The context used was: $context
        ''',
      );
      return null;
    }
  }

  static T? maybeOf<T extends DependencyContainer<Object?>>(
      BuildContext context, {
        bool listen = false,
      }) =>
      _findInjection(context, listen: listen, throwIfNotFound: false);

  static T of<T extends DependencyContainer<Object?>>(
      BuildContext context, {
        bool listen = false,
      }) =>
      _findInjection(context, listen: listen, throwIfNotFound: true)!;


  @override
  Widget buildWithChild(BuildContext context, Widget? child) => InheritedProvider<T>(
    create: (context) => injection..init(),
    dispose: (_, injection) => injection.dispose(),
    lazy: _lazy,
    builder: builder,
  );
}


class MultiDependencyProvider extends MultiProvider {
  /// {@macro multi_bloc_provider}
  MultiDependencyProvider({
    required List<SingleChildWidget> providers,
    required Widget child,
    Key? key,
  }) : super(key: key, providers: providers, child: child);
}