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
  final ApiService apiService;

  RootDependency({required this.apiService});


  void dispose() {
    // apiService.dispose()
  }
}
```


#### Step 2: Define the DependencyFactory

Create a class that extends `DependencyContainer` and initialize your dependencies:

```dart
class RootDependencyFactory extends DependencyFactory<RootDependency> {
  
  Future<RootDependency> create() async {
    return RootDependency(
      apiService: await ApiService.initialize(),
    );
  }
}
```

#### Step 3: Use `DependencyScope`

Wrap your app in a `DependencyScope` to provide dependencies:

```dart
void main() {
  runApp(
    DependencyScope<RootDependency, RootDependencyFactory>(
      dependency: RootDependencyFactory(),
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

### Example 2: 

```dart
final RootDependency dep = await RootFactory().create();

DependencyProvider<RootDependency>(
  dependency: dep,
  builder: (context) => YourWidget();
  // or
  child: YourWidget()
)
```

### Example 3: DependencyScope

```dart
DependencyScope<RootDependency, RootFactory>(
      factory: RootFactory(),
      builder: (BuildContext context) => Text('Inject'),
      placeholder: Text('Placeholder'),
      errorBuilder: (Object? error) => Text('Error'),
    ),
```



## Migration Guide

[link to migrate versions](MIGRATION.md)



## Code Coverage

![Codecov](https://codecov.io/gh/contributors-company/depend/graphs/sunburst.svg?token=DITZJ9E9OM)

---

This version reflects the latest changes and provides clear guidance for new users.