
import 'dart:async';

/// The API service for the example
class ApiService {
  ApiService();

  Future<ApiService> init() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    return this;
  }
}

/// The data source for the example
class AuthDataSource {
  final ApiService apiService;

  AuthDataSource({required this.apiService});

  Future<String> login() => Future.value('Server Token');
}

/// The repository for the example
final class AuthRepository extends IAuthRepository {
  AuthRepository({required this.dataSource}): _stream = StreamController.broadcast();

  final AuthDataSource dataSource;

  final StreamController _stream;

  @override
  Stream get stream => _stream.stream;

  @override
  Future<String> login() => dataSource.login();

  @override
  void dispose() {
    _stream.close();
  }
}

final class MockAuthRepository extends IAuthRepository {
  MockAuthRepository(): _stream = StreamController.broadcast();
  final StreamController _stream;

  @override
  void dispose() {
    _stream.close();
  }

  @override
  Future<String> login() async => Future.value('Mock token');

  @override
  Stream get stream => _stream.stream;

}


abstract class IAuthRepository {
  Stream get stream;
  Future<String> login();
  void dispose();
}