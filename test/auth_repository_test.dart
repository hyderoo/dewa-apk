import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart'; //
import 'package:dewa_wo_app/core/repositories/auth_repository.dart';
import 'package:dewa_wo_app/core/api/api_client.dart';
import 'package:dewa_wo_app/core/models/response/auth_response.dart';

// Mock ApiClient
class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('AuthRepository', () {
    late MockApiClient mockApiClient;
    late AuthRepository authRepository;

    setUp(() {
      mockApiClient = MockApiClient();
      authRepository = AuthRepository(mockApiClient);
    });

    test('should return AuthResponse when login with valid admin credentials', () async {
      final mockResponse = {
        "status": "success",
        "data": {
          "user": {
            "id": 1,
            "name": "Admin",
            "email": "admin@example.com"
          },
          "token": "mock_token_admin"
        }
      };

      when(mockApiClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/login'),
            data: mockResponse,
            statusCode: 200,
          ));

      final result = await authRepository.login(
        email: 'admin@example.com',
        password: 'password123',
      );

      expect(result.status, 'success');
      expect(result.data?.user?.email, 'admin@example.com');
    });
  });
}
