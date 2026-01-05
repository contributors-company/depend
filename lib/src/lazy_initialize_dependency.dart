/// A simple class for lazy initialization of dependencies.
/// This class allows you to define a factory function that will be called
/// only when the instance is accessed for the first time.
/// Example usage:
/// ```dart
/// final lazyService = LazyGet(() => ApiService());
/// // The ApiService instance is not created yet.
/// final serviceInstance = container.lazyService.instance; // Now the ApiService is created.
/// ```
class LazyGet<T> {
  /// Creates a [LazyGet] with the provided factory function.
  /// The factory function is called only when the [instance] is accessed for the first time.
  /// Example:
  /// ```dart
  /// final lazyService = LazyGet(() => ApiService());
  /// ```
  LazyGet(this._factory);

  final T Function() _factory;
  T? _instance;

  /// Returns the instance of type [T], initializing it if it hasn't been created yet.
  /// Example:
  /// ```dart
  /// final service = lazyService.instance;
  /// ```
  T get instance {
    _instance ??= _factory();
    return _instance!;
  }
}

/// A simple class for lazy initialization of dependencies that are created asynchronously.
/// This class allows you to define a factory function that returns a [Future],
/// which will be awaited only when the instance is accessed for the first time.
/// Example usage:
/// ```dart
/// final lazyService = LazyFutureGet(() async => await ApiService().init());
/// // The ApiService instance is not created yet.
/// final serviceInstance = await container.lazyService.instance; // Now the ApiService is created.
/// ```
class LazyFutureGet<T> {
  /// Creates a [LazyFutureGet] with the provided factory function.
  /// The factory function is called only when the [instance] is accessed for the first time
  /// and awaited.
  /// Example:
  /// ```dart
  /// final lazyService = LazyFutureGet(() async => await ApiService().init());
  /// ```
  LazyFutureGet(this._factory);

  final Future<T> Function() _factory;
  T? _instance;

  /// Returns a [Future] that completes with the instance of type [T],
  /// initializing it if it hasn't been created yet.
  /// Example:
  /// ```dart
  /// final service = await container.lazyService.instance;
  /// ```
  Future<T> get instance async {
    _instance ??= await _factory();
    return _instance!;
  }
}
