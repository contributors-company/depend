
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

1. [Depend](#depend)
2. [Features 🚀](#features-)
3. [Installation](#installation)
4. [Usage Examples](#usage-examples)
   - [Example 1: Simple Initialization](#example-1-simple-initialization)
      - [Step 1: Define the Dependency](#step-1-define-the-dependency)
      - [Step 2: Define the DependencyFactory](#step-2-define-the-dependencyfactory)
      - [Step 3: Use `DependencyScope`](#step-3-use-dependencyscope)
      - [Step 4: Access the Dependency in a Widget](#step-4-access-the-dependency-in-a-widget)
   - [Example 2: `DependencyProvider`](#example-2-dependencyprovider)
   - [Example 3: `DependencyScope`](#example-3-dependencyscope)
5. [Migration Guide](#migration-guide)
6. [Code Coverage](#code-coverage)

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
class RootContainer extends DependencyContainer {
  final ApiService apiService;

  RootContainer({required this.apiService});


  void dispose() {
    apiService.dispose();
  }
}
```


#### Step 2: Define the DependencyFactory

Create a class that extends `DependencyContainer` and initialize your dependencies:

```dart
class RootDependencyFactory extends DependencyFactory<RootContainer> {
  
  Future<RootContainer> create() async {
    return RootContainer(
      apiService: await ApiService.initialize(),
    );
  }
  
  
  // or

  RootContainer create() {
     return RootContainer(
        apiService: ApiService.initialize(),
     );
  }
}
```

#### Step 3: Use `DependencyScope`

Wrap your app in a `DependencyScope` to provide dependencies:

```dart
void main() {
  runApp(
    DependencyScope<RootContainer, RootFactory>(
       factory: RootFactory(), 
       placeholder: const Center(child: CircularProgressIndicator()), 
       builder: (BuildContext context) => const MyApp(),
    ),
  );
}
```

#### Step 4: Access the Dependency in a Widget

You can now access the dependency using `DependencyProvider` anywhere in the widget tree:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = DependencyProvider.of<RootContainer>(context).apiService;

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

### Example 2: `DependencyProvider`

```dart
final RootContainer dep = await RootFactory().create();

DependencyProvider<RootContainer>(
  dependency: dep,
  builder: () => YourWidget();
  // or
  child: YourWidget()
)

class YourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext) {
    root = DependencyProvider.of<RootContainer>(context);
    ...
  }
}
```

### Example 3: `DependencyScope`

```dart
DependencyScope<RootContainer, RootFactory>(
      factory: RootFactory(),
      builder: (BuildContext context) => Text('Inject'),
      placeholder: Text('Placeholder'),
      errorBuilder: (Object? error) => Text('Error'),
    ),
```



## Migration Guide

[link to migrate versions](https://github.com/contributors-company/depend/blob/main/MIGRATION.md)



## Code Coverage

![Codecov](https://codecov.io/gh/contributors-company/depend/graphs/sunburst.svg?token=DITZJ9E9OM)
