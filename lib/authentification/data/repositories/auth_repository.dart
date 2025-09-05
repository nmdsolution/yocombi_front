// lib/data/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_entity_request.dart';

abstract class AuthRepository {
  // Direct login with password (based on your Bruno file)
  Future<Either<Failure, Map<String, dynamic>>> login(AuthEntityRequest request);
  
  // OTP-based authentication
  Future<Either<Failure, Map<String, dynamic>>> sendOtp(AuthEntityRequest request);
  Future<Either<Failure, Map<String, dynamic>>> verifyOtp(AuthEntityRequest request);
  
  // Registration completion
  Future<Either<Failure, User>> completeRegistration(AuthEntityRequest request);
  
  // User management
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, void>> logout();
  Future<bool> isAuthenticated();
  
  // Token management
  Future<Either<Failure, String>> refreshToken();
}