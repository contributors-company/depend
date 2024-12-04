
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

  Future<String> login() => Future.value('Token');
}

/// The repository for the example
final class AuthRepository {
  final AuthDataSource dataSource;

  final StreamController _stream;

  Stream get stream => _stream.stream;

  AuthRepository({required this.dataSource}): _stream = StreamController.broadcast();

  Future<String> login() => dataSource.login();

  void dispose() {
    _stream.close();
  }
}