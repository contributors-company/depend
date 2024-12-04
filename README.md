Here’s the translated and updated `README.md` for the `depend` library:

---

# Depend

![Pub Version](https://img.shields.io/pub/v/depend)
![License](https://img.shields.io/github/license/AlexHCJP/depend)
![Coverage](https://img.shields.io/codecov/c/github/contributors-company/depend)
![Stars](https://img.shields.io/github/stars/AlexHCJP/depend)

`depend` is a library for dependency management in Flutter applications. It provides a convenient way to initialize and access services and repositories via `InheritedWidget`.

---

## Features 🚀

- **Dependency Initialization:** Prepare all dependencies before the app launches.
- **Global Access:** Access dependencies from anywhere in the widget tree.
- **Parent Dependencies Support:** Easily create nested or connected dependencies.
- **Ease of Use:** Integrate the library into existing code with minimal changes.

---

## Table of Contents

- [Installation](#installation)
- [Usage Examples](#usage-examples)
  - [Example 1: Simple Initialization](#example-1-simple-initialization)
  - [Example 2: Parent Dependencies](#example-2-parent-dependencies)
  - [Example 3: DependencyScope](#example-3-dependencyscope)
- [Migration Guide](#migration-guide)
  - [From Version 3 to Version 4](#from-version-3-to-version-4)
- [Code Coverage](#code-coverage)

---

## Installation

Add the library to the `pubspec.yaml` of your project:

```yaml
dependencies:
  depend: ^latest_version
```

Install the dependencies:

```bash
flutter pub get
```

---

## Usage Examples

### Example 1: Simple Initialization

#### Step 1: Define the Dependency

Create a class that extends `DependencyContainer` and initialize your dependencies:

```dart
class RootDependency extends DependencyContainer {
  late final ApiService apiService;

  @override
  Future<void> init() async {
    apiService = await ApiService().init();
  }

  void dispose() {
    // apiService.dispose()
  }
}
```

#### Step 2: Use `DependencyScope`

Wrap your app in a `DependencyScope` to provide dependencies:

```dart
void main() {
  runApp(
    DependencyScope<RootDependency>(
      dependency: RootDependency(),
      placeholder: const Center(child: CircularProgressIndicator()),
      builder: (BuildContext context) => const MyApp(),
    ),
  );
}
```

#### Step 3: Access the Dependency in a Widget

You can now access the dependency using `DependencyProvider` anywhere in the widget tree:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = DependencyProvider.of<RootDependency>(context).apiService;

    return FutureBuilder(
      future: apiService.getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return Text('Data: ${snapshot.data}');
      },
    );
  }
}
```

---

### Example 2: Parent Dependencies

#### Step 1: Create the Parent Dependency

```dart
class RootDependency extends DependencyContainer {
  late final ApiService apiService;

  @override
  Future<void> init() async {
    apiService = await ApiService().init();
  }
}
```

#### Step 2: Create the Child Dependency

Use the parent dependency inside the child:

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
}
```

#### Step 3: Link Both Dependencies

```dart
void main() {
  runApp(
    DependencyScope<RootDependency>(
      dependency: RootDependency(),
      builder: (BuildContext context) => DependencyScope<ModuleDependency>(
        dependency: ModuleDependency(
          parent: DependencyProvider.of<RootDependency>(context),
          // or
          // parent: context.depend<RootDependency>(),
        ),
        builder: (BuildContext context) => const MyApp(),
      ),
    ),
  );
}
```

---

### Example 3: DependencyScope

```dart
DependencyScope<RootDependency>(
      dependency: RootDependency(),
      builder: (BuildContext context) => Text('Inject'),
      placeholder: Text('Placeholder'),
      errorBuilder: (Object? error) => Text('Error'),
    ),
```

## Migration Guide

### From Version 3 to Version 4

#### Version 3:

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

#### Version 4:

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

#### Key Differences:
- `InjectionScope` → `DependencyScope`
- `Injection` → `DependencyContainer`
- `InjectionScope` → `DependencyProvider`

---

## Code Coverage

![Codecov](https://codecov.io/gh/contributors-company/depend/graphs/sunburst.svg?token=DITZJ9E9OM)

---

This version reflects the latest changes and provides clear guidance for new users.