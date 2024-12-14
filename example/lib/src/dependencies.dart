import 'package:depend/depend.dart';
import 'package:example/src/services.dart';
import 'package:flutter/foundation.dart';

class RootContainer extends DependencyContainer {
  final ApiService apiService;

  RootContainer({required this.apiService});
}

class AuthContainer extends DependencyContainer {
  final IAuthRepository authRepository;

  AuthContainer({required this.authRepository});

  @override
  void dispose() {
    authRepository.dispose();
  }
}

class RootFactory extends DependencyFactory<RootContainer> {
  @override
  Future<RootContainer> create() async {
    return RootContainer(
      apiService: await ApiService().init(),
    );
  }
}

class AuthFactory extends DependencyFactory<AuthContainer> {
  final ApiService _apiService;

  AuthFactory({required ApiService apiService}) : _apiService = apiService;

  @override
  AuthContainer create() {
    return AuthContainer(
      authRepository: kDebugMode
          ? MockAuthRepository()
          : AuthRepository(
              dataSource: AuthDataSource(
                apiService: _apiService,
              ),
            ),
    );
  }
}
