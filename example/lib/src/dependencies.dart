
import 'package:depend/depend.dart';
import 'package:example/src/services.dart';

class RootInjection extends DependencyContainer<void> {
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
