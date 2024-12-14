import 'package:depend/depend.dart';
import 'package:example/src/bloc/default_bloc.dart';
import 'package:example/src/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: DependencyScope<RootContainer, RootFactory>(
        factory: RootFactory(),
        placeholder: const ColoredBox(
          color: Colors.white,
          child: CupertinoActivityIndicator(),
        ),
        builder: (context) => DependencyScope<AuthContainer, AuthFactory>(
          factory: AuthFactory(
            apiService:
                DependencyProvider.of<RootContainer>(context).apiService,
          ),
          placeholder: const ColoredBox(
            color: Colors.white,
            child: CupertinoActivityIndicator(),
          ),
          builder: (context) => BlocProvider(
            create: (context) => DefaultBloc(
              DependencyProvider.of<AuthContainer>(context).authRepository,
            ),
            child: const MyHomePage(),
          ),
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
                  return Text(
                      'Login: ${state.authorized} \n\nToken: ${state.token}');
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
