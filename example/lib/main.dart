import 'package:depend/depend.dart';
import 'package:example/src/default_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootInjection extends DependencyContainer {
  late final ApiService apiService;

  @override
  Future<void> init() async {
    apiService = await ApiService().init();
  }

}

class ModuleInjection extends DependencyContainer<RootInjection> {
  late final AuthRepository authRepository;

  ModuleInjection({required super.parent});

  @override
  Future<void> init() async {
    authRepository = AuthRepository(
      dataSource: AuthDataSource(
        apiService: parent.apiService,
      ),
    );
  }

  @override
  void dispose() {
    authRepository.dispose();
  }
}

void main() {
  runApp(
    DependencyScope<RootInjection>(
      injection: RootInjection(),
      placeholder: const ColoredBox(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      ),
      builder: (context) => const MyApp(),
    ),
  );
}

/// The API service for the example
class ApiService {
  ApiService();

  Future<ApiService> init() async {
    return Future.delayed(const Duration(seconds: 1), () => this);
  }
}

/// The data source for the example
class AuthDataSource {
  final ApiService apiService;

  AuthDataSource({required this.apiService});

  Future<String> login() => Future.value('Token');
}

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
      home: DependencyScope<ModuleInjection>(
        injection: ModuleInjection(
          parent: DependencyProvider.of<RootInjection>(context),
        ),
        builder: (context) => BlocProvider(
          create: (context) => DefaultBloc(
            DependencyProvider.of<ModuleInjection>(context).authRepository,
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
