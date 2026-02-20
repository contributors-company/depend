/// A simple class for lazy initialization of dependencies.
/// This class allows you to define a factory function that will be called only when the instance is accessed for the first time.
/// Example usage:
/// ```dart
/// final lazyService = LazyGet(() => ApiService());
/// // The ApiService instance is not created yet.
/// final serviceInstance = container.lazyService.instance; // Now the ApiService is created.
/// ```
class LazyGet<T> {
  /// Creates a [LazyGet] instance with the provided factory function.
  /// The factory function will be called only when the instance is accessed for the first time.
  /// Example usage:
  /// ```dart
  /// final lazyService = LazyGet(() => ApiService());
  /// // The ApiService instance is not created yet.
  /// final serviceInstance = container.lazyService.instance; // Now the ApiService is created.
  /// ```
  LazyGet(this._factory);

  final T Function() _factory;
  T? _instance;

  /// Returns the instance of the dependency. If the instance has not been created yet, it will be created using the factory function.
  T get instance {
    if (_instance != null) {
      return _instance as T;
    }
    _instance ??= _factory();
    return _instance as T;
  }
}

/// A simple class for lazy initialization of dependencies that are created asynchronously.
/// This class allows you to define a factory function that returns a [Future],
/// which will be awaited only when the instance is accessed for the first time.
/// Example usage:
/// ```dart
/// final lazyService = LazyFutureGet(() async => await ApiService().init());
/// // The ApiService instance is not created yet.
/// final serviceInstance = await container.lazyService(); // Now the ApiService is created.
/// ```
class LazyFutureGet<T> {
  /// Creates a [LazyFutureGet] instance with the provided factory function.
  /// The factory function should return a [Future] that will be awaited when the instance is accessed for the first time.
  /// Example usage:
  /// ```dart
  /// final lazyService = LazyFutureGet(() async => await ApiService().init());
  /// // The ApiService instance is not created yet.
  /// final serviceInstance = await container.lazyService(); // Now the ApiService is created.
  /// ```
  LazyFutureGet(this._factory);

  final Future<T> Function() _factory;
  T? _instance;
  Future<T>? _pendingFuture;

  /// Returns a [Future] that resolves to the instance of the dependency. If the instance has not been created yet, it will be created using the factory function.
  Future<T> get instance {
    if (_instance != null) {
      return Future.value(_instance);
    }
    _pendingFuture ??= _factory().then((value) {
      _instance = value;
      _pendingFuture = null;
      return value;
    });
    return _pendingFuture!;
  }
}