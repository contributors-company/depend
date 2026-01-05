import 'package:depend/depend.dart';
import 'package:example/src/services.dart';
import 'package:flutter/foundation.dart';

class RootContainer extends DependencyContainer {
  final ApiService apiService;
  final LazyGet<ApiService> lazyApiService;
  final LazyFutureGet<ApiService> lazyFutureApiService;

  RootContainer({
    required this.apiService,
    required this.lazyApiService,
    required this.lazyFutureApiService,
  });
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
    final container = RootContainer(
      apiService: ApiService(),
      lazyApiService: LazyGet(() => ApiService()),
      lazyFutureApiService: LazyFutureGet(() => ApiService().init()),
    );
    return container;
  }
}

class AuthFactory extends DependencyFactory<AuthContainer> {
  final ApiService _apiService;

  AuthFactory(this._apiService);

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
