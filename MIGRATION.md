## [v4 to v5](#from-version-4-to-version-5)
## [v4 to v5](#from-version-3-to-version-4)


## From Version 4 to Version 5

### Version 4:

```dart
class RootFactory extends DependencyFactory<RootDependency> {
  @override
  Future<RootDependency> create() async {
    return RootDependency(
      apiService: await ApiService().init(),
    );
  }
}
```

```dart
class RootDependency extends DependencyContainer {
  final AuthRepository authRepository;

  ModuleDependency({required super.authRepository});

  void dispose() {
    // authRepository.dispose();
  }
}
```

```dart
DependencyScope<RootDependency, RootFactory>(
    factory: RootFactory(),
    placeholder: const Center(child: CircularProgressIndicator()),
    builder: (context) => const YourWidget(),
);
```


```dart
final rootDependency = await RootFactory().create();

DependencyProvider<RootDependency>(
    dependency: rootDependency,
    child: const YourWidget(),
);
```



### Version 5:

```dart
DependencyScope<RootDependency>(
    dependency: RootDependency(),
    placeholder: const Center(child: CircularProgressIndicator()),
    builder: (context) => const YourWidget(),
);
```

```dart
class ModuleDependency extends DependencyContainer<RootDependency> {
  late final AuthRepository authRepository;

  ModuleDependency({required super.parent});

  @override
  Future<void> init() async {
    authRepository = AuthRepository(
      apiService: parent.apiService,
    );
  }

  void dispose() {
    // authRepository.dispose();
  }
}
```

```dart
DependencyProvider.of<ModuleDependency>(context);
DependencyProvider.maybeOf<ModuleDependency>(context);
// or
context.depend<ModuleDependency>();
context.dependMaybe<ModuleDependency>();
```

## From Version 3 to Version 4

### Version 3:

```dart
InjectionScope<RootLibrary>(
  library: RootLibrary(),
  placeholder: const Center(child: CircularProgressIndicator()),
  child: const YourWidget(),
);
```

```dart
class RootInjection extends Injection {
  late final ApiService apiService;

  @override
  Future<void> init() async {
    apiService = await ApiService().init();
  }
}
```

```dart
InjectionScope.of<ModuleInjection>(context);
```

### Version 4:

```dart
DependencyScope<RootDependency>(
    dependency: RootDependency(),
    placeholder: const Center(child: CircularProgressIndicator()),
    builder: (context) => const YourWidget(),
);
```

```dart
class ModuleDependency extends DependencyContainer<RootDependency> {
  late final AuthRepository authRepository;

  ModuleDependency({required super.parent});

  @override
  Future<void> init() async {
    authRepository = AuthRepository(
      apiService: parent.apiService,
    );
  }

  void dispose() {
    // authRepository.dispose();
  }
}
```

```dart
DependencyProvider.of<ModuleDependency>(context);
DependencyProvider.maybeOf<ModuleDependency>(context);
// or
context.depend<ModuleDependency>();
context.dependMaybe<ModuleDependency>();
```
