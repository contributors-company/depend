import 'package:depend/depend.dart';
import 'package:example/src/services.dart';

class RootDependency extends DependencyContainer {
  final ApiService apiService;

  RootDependency({required this.apiService});
}

class ModuleDependency extends DependencyContainer {
  final AuthRepository authRepository;

  ModuleDependency({required this.authRepository});

  @override
  void dispose() {
    authRepository.dispose();
  }
}

class RootFactory extends DependencyFactory<RootDependency> {
  @override
  Future<RootDependency> create() async {
    return RootDependency(
      apiService: await ApiService().init(),
    );
  }
}

class ModuleFactory extends DependencyFactory<ModuleDependency> {
  final RootDependency _rootInjection;

  ModuleFactory({required RootDependency rootInjection})
      : _rootInjection = rootInjection;

  @override
  Future<ModuleDependency> create() async {
    return ModuleDependency(
      authRepository: AuthRepository(
        dataSource: AuthDataSource(
          apiService: _rootInjection.apiService,
        ),
      ),
    );
  }
}
