import 'package:dewa_wo_app/core/api/api_client.dart';
import 'package:dewa_wo_app/core/models/request/profile_request.dart';
import 'package:dewa_wo_app/core/models/response/generic_response.dart';
import 'package:dewa_wo_app/core/models/response/profile_response.dart';
import 'package:dewa_wo_app/core/models/user_model.dart';
import 'package:dewa_wo_app/core/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ProfileRepository {
  final ApiClient _apiClient;
  final AuthRepository _authRepository;

  ProfileRepository({
    required ApiClient apiClient,
    required AuthRepository authRepository,
  })  : _apiClient = apiClient,
        _authRepository = authRepository;

  Future<ProfileResponse> updateProfile({
    required UpdateProfileRequest request,
  }) async {
    try {
      final data = request.toJson();
      data.remove('avatar');
      FormData formData = FormData.fromMap({
        ...data,
        if (request.avatar != null)
          'avatar': await MultipartFile.fromFile(request.avatar!),
        '_method': 'PUT',
      });
      final response = await _apiClient.post('/profile', data: formData);

      final profileResponse = ProfileResponse.fromJson(response.data);

      if (profileResponse.status == 'success' && profileResponse.data != null) {
        await _authRepository.saveUser(profileResponse.data!);
      }

      return profileResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        try {
          return ProfileResponse.fromJson(e.response!.data);
        } catch (_) {
          return ProfileResponse(
            status: 'error',
            message: e.message ?? 'Failed to update profile',
            data: null,
          );
        }
      }

      return ProfileResponse(
        status: 'error',
        message: e.message ?? 'Network error occurred',
        data: null,
      );
    } catch (e) {
      return ProfileResponse(
        status: 'error',
        message: e.toString(),
        data: null,
      );
    }
  }

  Future<GenericResponse> changePassword({
    required ChangePasswordRequest request,
  }) async {
    try {
      final response = await _apiClient.post(
        '/profile/password',
        data: request.toJson(),
      );

      return GenericResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        try {
          return GenericResponse.fromJson(e.response!.data);
        } catch (_) {
          return GenericResponse(
            status: 'error',
            message: e.message ?? 'Failed to change password',
            data: null,
          );
        }
      }

      return GenericResponse(
        status: 'error',
        message: e.message ?? 'Network error occurred',
        data: null,
      );
    } catch (e) {
      return GenericResponse(
        status: 'error',
        message: e.toString(),
        data: null,
      );
    }
  }

  Future<GenericResponse> deleteAccount({
    required DeleteAccountRequest request,
  }) async {
    try {
      final response = await _apiClient.post(
        '/profile',
        data: request.toJson()
          ..addAll({
            '_method': 'DELETE',
          }),
      );

      final genericResponse = GenericResponse.fromJson(response.data);

      if (genericResponse.status == 'success') {
        await _authRepository.clearAuthData();
      }

      return genericResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        try {
          return GenericResponse.fromJson(e.response!.data);
        } catch (_) {
          return GenericResponse(
            status: 'error',
            message: e.message ?? 'Failed to delete account',
            data: null,
          );
        }
      }

      return GenericResponse(
        status: 'error',
        message: e.message ?? 'Network error occurred',
        data: null,
      );
    } catch (e) {
      return GenericResponse(
        status: 'error',
        message: e.toString(),
        data: null,
      );
    }
  }

  UserModel? getCurrentUser() {
    return _authRepository.getUser();
  }
}
