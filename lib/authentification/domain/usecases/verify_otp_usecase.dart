// lib/domain/usecases/verify_otp_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/auth_entity_request.dart';

class VerifyOtpUsecase {
  final AuthRepository repository;

  VerifyOtpUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(AuthEntityRequest request) async {
    return await repository.verifyOtp(request);
  }
}