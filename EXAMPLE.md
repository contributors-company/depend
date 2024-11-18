
# depend

![Pub Version](https://img.shields.io/pub/v/depend)
![License](https://img.shields.io/github/license/AlexHCJP/depend)
![Issues](https://img.shields.io/github/issues/AlexHCJP/depend)
![Coverage](https://img.shields.io/codecov/c/github/contributors-company/depend)
![Stars](https://img.shields.io/github/stars/AlexHCJP/depend)
![Contributors](https://img.shields.io/github/contributors/AlexHCJP/depend)
![Watchers](https://img.shields.io/github/watchers/AlexHCJP/depend)
![Forks](https://img.shields.io/github/forks/AlexHCJP/depend)

`depend` is a library for managing dependencies in Flutter applications. It provides a convenient way to initialize and access services or repositories via an `InheritedWidget`.

---

## Why it Rocks 🚀

- Initialize dependencies before launching the app
- Access dependencies from anywhere in the widget tree
- Log initialization times for each dependency
- Clean and extensible way to manage dependencies
- Easy to use and integrate with existing codebases

---

- [dependencies](#dependencies)
    - [Why it Rocks 🚀](#why-it-rocks-)
    - [Installation](#installation)
    - [Example Usage](#example-usage)
        - [Example 1: Define Dependencies](#example-1-define-dependencies)
          - [Step 2: Initialize Dependencies](#step-2-initialize-dependencies)
          - [Step 3: Access Dependencies with `InheritedWidget`](#step-3-access-dependencies-with-inheritedwidget)
        - [Example 2: Use Parent Dependencies](#example-2-use-parent-dependencies)
          - [Step 1: Define Parent Dependencies](#step-1-define-parent-dependencies)
    - [Logging and Debugging](#logging-and-debugging)

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  depend: ^0.0.1
```

Then run:

```bash
$ flutter pub get
```
---

## Example Usage

### Example 1: Define Dependencies

#### Step 1: Extends `DependenciesLibrary`

Create a `DependenciesLibrary` that extends `DependenciesLibrary` and initializes your dependencies:

```dart
class RootLibrary extends DependenciesLibrary {
  late final ApiService apiService;

  @override
  Future<void> init() async {
    await log(() async => apiService = await ApiService().init());
  }
}
```

#### Step 2: Initialize Dependencies

Use `DependenciesInit` to initialize your dependencies before launching the app:

```dart
void main() {
  runApp(
    Dependencies<RootLibrary>(
      library: RootLibrary(),
      placeholder: const ColoredBox(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      ),
      child: const MyApp(),
    ),
  );
}
```

#### Step 3: Access Dependencies with `InheritedWidget`

Once initialized, dependencies can be accessed from anywhere in the widget tree using `Dependencies.of(context).authRepository`:

```dart

/// The repository for the example
final class AuthRepository {
  final AuthDataSource dataSource;

  AuthRepository({required this.dataSource});

  Future<String> login() => dataSource.login();
  
  void dispose() {
    // stream.close();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Dependencies<ModuleLibrary>(
        library: ModuleLibrary(
          parent: Dependencies.of<RootLibrary>(context),
        ),
        child: BlocProvider(
          create: (context) => DefaultBloc(
            Dependencies.of<ModuleLibrary>(context).authRepository,
          ),
          child: const MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _login() {
    context.read<DefaultBloc>().add(DefaultEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<DefaultBloc, DefaultState>(
                builder: (context, state) {
                  return Text('Login: ${state.authorized}');
                },
              ),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

```

### Example 2: Use Parent Dependencies

#### Step 1: Define Parent Dependencies

```dart

class RootLibrary extends DependenciesLibrary {
  late final ApiService apiService;

  @override
  Future<void> init() async {
    apiService = await ApiService().init();
  }
}

class ModuleLibrary extends DependenciesLibrary<RootLibrary> {
  late final AuthRepository authRepository;

  ModuleLibrary({required super.parent});

  @override
  Future<void> init() async {
    // initialize dependencies
    authRepository = AuthRepository(
      dataSource: AuthDataSource(
        apiService: parent.apiService, // parent - RootLibrary
      ),
    );
  }

  @override
  void dispose() {
    authRepository.dispose();
  }
}



```

## Logging and Debugging

During initialization, each dependency logs the time it took to initialize:

```dart
class ModuleLibrary extends DependenciesLibrary<RootLibrary> {
  late final AuthRepository authRepository;

  ModuleLibrary({required super.parent});

  @override
  Future<void> init() async {
    await log(() async => authRepository = AuthRepository(
          dataSource: AuthDataSource(
            apiService: parent.apiService,
          ),
        ),
    );
  }
}
```

```dart
💡 ApiService: initialized successfully for 10 ms
💡 AuthRepository: initialized successfully for 0 ms
```

This is useful for tracking performance and initialization times.

## Codecov

![Codecov](https://codecov.io/gh/contributors-company/depend/graphs/sunburst.svg?token=DITZJ9E9OM)
