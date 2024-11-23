
# depend

![Pub Version](https://img.shields.io/pub/v/depend)
![License](https://img.shields.io/github/license/AlexHCJP/depend)
![Coverage](https://img.shields.io/codecov/c/github/contributors-company/depend)
![Stars](https://img.shields.io/github/stars/AlexHCJP/depend)

`depend` is a library for managing dependencies in Flutter applications. It provides a convenient way to initialize and access services or repositories via an `InheritedWidget`.

---

## Why it Rocks 🚀

- Initialize dependencies before launching the app
- Access dependencies from anywhere in the widget tree
- Clean and extensible way to manage dependencies
- Easy to use and integrate with existing codebases

---

- **[dependencies](#depend)**
    - **[Why it Rocks 🚀](#why-it-rocks-)**
    - **[Installation](#installation)**
    - **[Example Usage](#example-usage)**
        - **[Example 1: Define InjectionScope](#example-1-define-injectionscope)**
            - **[Step 2: Initialize InjectionScope](#step-2-initialize-injectionscope)**
            - **[Step 3: Access InjectionScope with `InheritedWidget`](#step-3-access-injectionscope-with-inheritedwidget)**
        - **[Example 2: Use Parent InjectionScope](#example-2-use-parent-injectionscope)**
            - **[Step 1: Define Parent InjectionScope](#step-1-define-parent-injectionscope)**
    - **[Migrate v2 to v3](#migrate-from-v2-to-v3)**

---

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  depend: ^latest_version
```

Then run:

```bash
$ flutter pub get
```
---

## Example Usage

### Example 1: Define InjectionScope

#### Step 1: Extends `Injection`

Create a `Injection` that extends `Injection` and initializes your dependencies:

```dart
class RootInjection extends Injection {
  late final ApiService apiService;

  @override
  Future<void> init() async {
    apiService = await ApiService().init()
  }
}
```

#### Step 2: Initialize InjectionScope

Use `InjectionScope` to initialize your dependencies before launching the app:

```dart
void main() {
  runApp(
    InjectionScope<RootInjection>(
      injection: RootInjection(),
      placeholder: const ColoredBox(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      ),
      child: const MyApp(),
    ),
  );
}
```

#### Step 3: Access InjectionScope with `InheritedWidget`

Once initialized, dependencies can be accessed from anywhere in the widget tree using `InjectionScope.of(context).authRepository`:

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
      home: InjectionScope<ModuleInjection>(
        injection: ModuleInjection(
          parent: InjectionScope.of<RootInjection>(context),
        ),
        child: BlocProvider(
          create: (context) => DefaultBloc(
            InjectionScope.of<ModuleInjection>(context).authRepository,
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

### Example 2: Use Parent InjectionScope

#### Step 1: Define Parent InjectionScope

```dart

class RootInjection extends Injection {
  late final ApiService apiService;

  @override
  Future<void> init() async {
    apiService = await ApiService().init();
  }
}

class ModuleInjection extends Injection<RootInjection> {
  late final AuthRepository authRepository;

  ModuleInjection({required super.parent});

  @override
  Future<void> init() async {
    // initialize dependencies
    authRepository = AuthRepository(
      dataSource: AuthDataSource(
        apiService: parent.apiService, // parent - RootInjection
      ),
    );
  }

  @override
  void dispose() {
    authRepository.dispose();
  }
}



```
### Migrate from v2 to v3

In version 2, dependencies were injected using `Dependencies`, but in version 3, this has been replaced by `InjectionScope`. Here's how you would migrate:

#### v2:
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

#### v3:
```dart
void main() {
  runApp(
    InjectionScope<RootInjection>(
      injection: RootInjection(),
      placeholder: const ColoredBox(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      ),
      child: const MyApp(),
    ),
  );
}
```

The key change is moving from `Dependencies` to `InjectionScope`, reflecting the updated structure for managing and accessing dependencies.

---

### v2:
```dart
class RootLibrary extends DependenciesLibrary {
  late final ApiService apiService;

  @override
  Future<void> init() async {
    apiService = await ApiService().init();
  }
}
```

### v3:
```dart
class RootInjection extends Injection {
  late final ApiService apiService;

  @override
  Future<void> init() async {
    apiService = await ApiService().init();
  }
}
```

The primary change here is the renaming of `RootLibrary` to `RootInjection`, aligning with the shift in naming conventions from `DependenciesLibrary` in v2 to `Injection` in v3.

## Codecov

![Codecov](https://codecov.io/gh/contributors-company/depend/graphs/sunburst.svg?token=DITZJ9E9OM)
