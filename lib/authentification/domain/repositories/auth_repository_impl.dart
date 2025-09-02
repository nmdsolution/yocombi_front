// lib/authentification/domain/repositories/AuthRepositoryImpl.dart
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../core/errors/error_messages.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/network_info.dart';
import '../../../core/storage/secure_storage.dart';
import '../entities/user.dart';
import '../entities/auth_entity_request.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final http.Client client;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.client,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> login(AuthEntityRequest request) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.login(request);
      
      // Handle successful login response
      if (response.containsKey('user') && response.containsKey('token')) {
        await _saveAuthData(
          token: response['token'] as String,
          tokenType: response['token_type'] as String? ?? 'Bearer',
          expiresIn: response['expires_in'] as int? ?? 3600,
          user: User.fromJson(response['user'] as Map<String, dynamic>),
        );
      }
      
      return Right(response);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final errorMessage = e.message ?? 'Login failed';

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: statusCode,
        userFriendlyMessage:
            ErrorMessageHandler.getFriendlyMessage(statusCode: statusCode),
      ));
    } on http.ClientException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 0,
        userFriendlyMessage: 'Connection error. Please try again.',
      ));
    } on FormatException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 400,
        userFriendlyMessage: 'Invalid server response format.',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendOtp(AuthEntityRequest request) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.sendOtp(request);
      return Right(response);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final errorMessage = e.message ?? 'Failed to send OTP';

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: statusCode,
        userFriendlyMessage:
            ErrorMessageHandler.getFriendlyMessage(statusCode: statusCode),
      ));
    } on http.ClientException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 0,
        userFriendlyMessage: 'Connection error. Please try again.',
      ));
    } on FormatException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 400,
        userFriendlyMessage: 'Invalid server response format.',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyOtp(AuthEntityRequest request) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.verifyOtp(request);
      
      // If it's a login verification, save auth data immediately
      if (request.type == 'login' && response.containsKey('user') && response.containsKey('token')) {
        await _saveAuthData(
          token: response['token'] as String,
          tokenType: response['token_type'] as String? ?? 'Bearer',
          expiresIn: response['expires_in'] as int? ?? 3600,
          user: User.fromJson(response['user'] as Map<String, dynamic>),
        );
      }
      
      return Right(response);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final errorMessage = e.message ?? 'Invalid OTP';

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: statusCode,
        userFriendlyMessage:
            ErrorMessageHandler.getFriendlyMessage(statusCode: statusCode),
      ));
    } on http.ClientException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 0,
        userFriendlyMessage: 'Connection error. Please try again.',
      ));
    } on FormatException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 400,
        userFriendlyMessage: 'Invalid server response format.',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> completeRegistration(AuthEntityRequest request) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final authResponse = await remoteDataSource.completeRegistration(request);
      await _saveAuthData(
        token: authResponse.token,
        tokenType: authResponse.tokenType,
        expiresIn: authResponse.expiresIn,
        user: authResponse.user,
      );
      return Right(authResponse.user);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final errorMessage = e.message ?? 'Registration failed';

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: statusCode,
        userFriendlyMessage:
            ErrorMessageHandler.getFriendlyMessage(statusCode: statusCode),
      ));
    } on http.ClientException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 0,
        userFriendlyMessage: 'Connection error. Please try again.',
      ));
    } on FormatException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 400,
        userFriendlyMessage: 'Invalid server response format.',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userData = await SecureStorage.getUserData();
      if (userData == null) return const Right(null);

      final userJson = jsonDecode(userData) as Map<String, dynamic>;
      final user = User.fromJson(userJson);
      return Right(user);
    } on FormatException {
      return const Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'Failed to load user data.',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await SecureStorage.clearAll();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return await SecureStorage.isLoggedIn();
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveAuthData({
    required String token,
    required String tokenType,
    required int expiresIn,
    required User user,
  }) async {
    try {
      await Future.wait([
        SecureStorage.saveToken(token),
        SecureStorage.saveTokenType(tokenType),
        SecureStorage.saveExpiresIn(expiresIn),
        SecureStorage.saveUserData(jsonEncode(user.toJson())),
      ]);
    } catch (e) {
      throw const CacheFailure();
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.refreshToken();
        return Right(result);
      } on FormatException {
        return const Left(CacheFailure());
      } catch (e) {
        return Left(ServerFailure(
          message: e.toString(),
          statusCode: 500,
          userFriendlyMessage: 'Failed to refresh token.',
        ));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}