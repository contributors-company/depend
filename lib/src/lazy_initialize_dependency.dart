/// A simple class for lazy initialization of dependencies.
/// This class allows you to define a factory function that will be called only when the instance is accessed for the first time.
/// Example usage:
/// ```dart
/// final lazyService = LazyGet(() => ApiService());
/// // The ApiService instance is not created yet.
/// final serviceInstance = container.lazyService(); // Now the ApiService is created.
/// ```
LazyGet<T> lazyGet<T>(T Function() factory) {
  T? instance;
  return () {
    instance ??= factory();
    return instance!;
  };
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
LazyFutureGet<T> lazyFutureGet<T>(Future<T> Function() factory) {
  T? instance;
  return () async {
    if (instance != null) {
      return instance as T;
    }
    instance ??= await factory();
    return instance as T;
  };
}

/// A simple class for lazy initialization of dependencies that are created asynchronously.
/// This class allows you to define a factory function that returns a [Future],
/// which will be awaited only when the instance is accessed for the first time.
typedef LazyGet<T> = T Function();

/// A simple class for lazy initialization of dependencies that are created asynchronously.
/// This class allows you to define a factory function that returns a [Future],
/// which will be awaited only when the instance is accessed for the first time.
typedef LazyFutureGet<T> = Future<T> Function();
