// lib/authentification/data/datasource/AuthRemoteDataSource.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../domain/entities/auth_entity_request.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(AuthEntityRequest request);
  Future<Map<String, dynamic>> sendOtp(AuthEntityRequest request);
  Future<Map<String, dynamic>> verifyOtp(AuthEntityRequest request);
  Future<AuthResponseModel> completeRegistration(AuthEntityRequest request);
  Future<String> refreshToken();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Map<String, dynamic>> login(AuthEntityRequest request) async {
    try {
      print('Direct login with data: ${request.toString()}');

      final requestData = {
        'identifier': request.identifier,
        'password': request.password,
      };

      print('Login request data: $requestData');

      final response = await dioClient.dio.post(
        AppConstants.loginEndpoint,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        final errorMessage = response.data['message'] ?? 'Login failed';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in login: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Login failed';
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? errorMessage;
        }
      }

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: errorMessage,
        error: e.error,
        type: e.type,
      );
    } catch (e) {
      print('General error in login: $e');
      throw DioException(
        requestOptions: RequestOptions(path: AppConstants.loginEndpoint),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> sendOtp(AuthEntityRequest request) async {
    try {
      print('Sending OTP with data: ${request.toString()}');

      final requestData = {
        'identifier': request.identifier,
        'type': request.type,
      };

      print('Send OTP request data: $requestData');

      final response = await dioClient.dio.post(
        AppConstants.sendOtpEndpoint,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('Send OTP response status: ${response.statusCode}');
      print('Send OTP response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to send OTP';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in sendOtp: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to send OTP';
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? errorMessage;
        }
      }

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: errorMessage,
        error: e.error,
        type: e.type,
      );
    } catch (e) {
      print('General error in sendOtp: $e');
      throw DioException(
        requestOptions: RequestOptions(path: AppConstants.sendOtpEndpoint),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(AuthEntityRequest request) async {
    try {
      print('Verifying OTP with data: ${request.toString()}');

      final requestData = {
        'identifier': request.identifier,
        'code': request.code,
        'type': request.type,
      };

      print('Verify OTP request data: $requestData');

      final response = await dioClient.dio.post(
        AppConstants.verifyOtpEndpoint,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('Verify OTP response status: ${response.statusCode}');
      print('Verify OTP response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        final errorMessage = response.data['message'] ?? 'Invalid OTP';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in verifyOtp: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Invalid OTP';
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? errorMessage;
        }
      }

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: errorMessage,
        error: e.error,
        type: e.type,
      );
    } catch (e) {
      print('General error in verifyOtp: $e');
      throw DioException(
        requestOptions: RequestOptions(path: AppConstants.verifyOtpEndpoint),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<AuthResponseModel> completeRegistration(AuthEntityRequest request) async {
    try {
      print('Completing registration with data: ${request.toString()}');

      final requestData = {
        'identifier': request.identifier,
        'name': request.name,
        'password': request.password,
        'password_confirmation': request.passwordConfirmation,
        'session_token': request.sessionToken,
        'user_type': request.userType ?? 'individual',
        'account_type': request.accountType ?? 'client',
      };

      print('Complete registration request data: $requestData');

      final response = await dioClient.dio.post(
        AppConstants.completeRegistrationEndpoint,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('Complete registration response status: ${response.statusCode}');
      print('Complete registration response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        // Transform the response to match our existing AuthResponseModel structure
        return AuthResponseModel.fromJson({
          'message': responseData['message'] ?? 'Registration completed successfully',
          'user': responseData['user'],
          'token': responseData['token'] ?? '',
          'token_type': responseData['token_type'] ?? 'Bearer',
          'expires_in': responseData['expires_in'] ?? 3600,
        });
      } else {
        final errorMessage = response.data['message'] ?? 'Registration failed';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in completeRegistration: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Registration failed';
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? errorMessage;
        }
      }

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: errorMessage,
        error: e.error,
        type: e.type,
      );
    } catch (e) {
      print('General error in completeRegistration: $e');
      throw DioException(
        requestOptions: RequestOptions(path: AppConstants.completeRegistrationEndpoint),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<String> refreshToken() async {
    try {
      final response = await dioClient.dio.post(
        AppConstants.refreshTokenEndpoint,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['token'] ?? data['access_token'] ?? '';
      } else {
        final errorMessage = response.data['message'] ?? 'Token refresh failed';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.response?.data['message'] ?? e.message ?? 'Token refresh failed',
        error: e.error,
        type: e.type,
      );
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: AppConstants.refreshTokenEndpoint),
        message: e.toString(),
        error: e,
      );
    }
  }
}