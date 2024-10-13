import 'package:depend/depend.dart';
import 'package:flutter/material.dart';

List<DependenciesProgress> progress = [
  (progress) async => ApiService(),
  (progress) async {
    return AuthRepository(
      dataSource: AuthDataSource(
        apiService: progress.dependencies.get<ApiService>(),
      ),
    );
  },
];

void main() async {
  final dependencies = await DependenciesInit().init(progress: progress);

  runApp(
    MyApp(
      dependencies: dependencies,
    ),
  );
}

/// The API service for the example
class ApiService extends Dependency {
  ApiService() {
    for (var i = 0; i < 1000000000; i++) {}
  }
}

/// The data source for the example
class AuthDataSource {
  final ApiService apiService;

  AuthDataSource({required this.apiService});

  Future<String> login() => Future.value('Token');
}

/// The repository for the example
final class AuthRepository extends Dependency {
  final AuthDataSource dataSource;

  AuthRepository({required this.dataSource});

  Future<String> login() => dataSource.login();
}

class MyApp extends StatelessWidget {
  final DependenciesLibrary dependencies;
  const MyApp({super.key, required this.dependencies});

  @override
  Widget build(BuildContext context) {
    return Dependencies(
      dependencies: dependencies,
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: MyHomePage(),
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
  bool isLogin = false;

  void _login() {
    Dependencies.of(context).get<AuthRepository>().login().then((value) {
      setState(() {
        isLogin = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Login: $isLogin'),
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
