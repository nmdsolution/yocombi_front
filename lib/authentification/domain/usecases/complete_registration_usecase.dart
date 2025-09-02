// lib/domain/usecases/complete_registration_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../entities/auth_entity_request.dart';
import '../../data/repositories/auth_repository.dart';

class CompleteRegistrationUsecase {
  final AuthRepository repository;

  CompleteRegistrationUsecase(this.repository);

  Future<Either<Failure, User>> call(AuthEntityRequest request) async {
    return await repository.completeRegistration(request);
  }
}