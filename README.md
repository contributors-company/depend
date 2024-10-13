
# dependencies

`dependencies` is a library for managing dependencies in Flutter applications. It provides a convenient way to initialize and access services or repositories via an `InheritedWidget`.

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
        - [Example 1: Create a List of Dependencies](#step-1-create-a-list-of-dependencies)
        - [Step 2: Initialize Dependencies](#step-2-initialize-dependencies)
        - [Step 3: Access Dependencies with `InheritedWidget`](#step-3-access-dependencies-with-inheritedwidget)
        - [Example 2: Example Usage with `Bloc`](#step-4-example-usage-with-bloc)
    - [Logging and Debugging](#logging-and-debugging)
    - [Conclusion](#conclusion)

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

#### Step 1: Create a List of Dependencies

Start by creating a list of dependencies that will be initialized when your app starts. Each dependency can rely on another through `DependenciesProgress`:

```dart
List<DependenciesProgress> progress = [
  (progress) async => ApiService(), // Example of an independent dependency
  (progress) async {
    return AuthRepository(
      dataSource: AuthDataSource(
        apiService: progress.dependencies.get<ApiService>(),
      ),
    );
  },
];
```

#### Step 2: Initialize Dependencies

Use `DependenciesInit` to initialize your dependencies before launching the app:

```dart
void main() async {
  final dependencies = await DependenciesInit(progress: progress);

  runApp(
    MyApp(
      dependencies: dependencies,
    ),
  );
}
```

#### Step 3: Access Dependencies with `InheritedWidget`

Once initialized, dependencies can be accessed from anywhere in the widget tree using `Dependencies.of(context).get<T>()`:

```dart
class MyApp extends StatelessWidget {
  final DependenciesLibrary dependencies;

  const MyApp({super.key, required this.dependencies});

  @override
  Widget build(BuildContext context) {
    return Dependencies(
      dependencies: dependencies,
      child: MaterialApp(
        title: 'Flutter Demo',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLogin = false;

  void _login() {
    try {
      Dependencies.of(context).get<AuthRepository>().login();
      setState(() {
        isLogin = true;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Login: $isLogin'),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Example 2: Example Usage with `Bloc`

You can also use `dependencies` with `Bloc` for state management. Here’s an example where the `AuthRepository` is injected into an `AuthBloc`:

```dart
/// Authentication BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_login);
  }
}
```

```dart
BlocProvider(
    create: (context) => AuthBloc(
      authRepository: Dependencies.of(context).get<AuthRepository>(),
    ),
),
```


In this example:
- We create an `AuthBloc` that depends on `AuthRepository` (which is initialized through the `dependencies` library).
- The `AuthBloc` is provided using `BlocProvider`, and we inject the `AuthRepository` from the dependencies into the BLoC.
- The UI responds to authentication events and displays different states like `AuthSuccess` or `AuthFailure`.

## Logging and Debugging

During initialization, each dependency logs the time it took to initialize:

```dart
💡 ApiService: initialized successfully for 10 ms
💡 AuthRepository: initialized successfully for 0 ms
```

This is useful for tracking performance and initialization times.

## Conclusion

The `dependencies` library provides a clean and extensible way to manage dependencies in your Flutter app, including integration with `Bloc` for state management.
