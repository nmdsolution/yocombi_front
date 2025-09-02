// lib/domain/usecases/login_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/auth_entity_request.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(AuthEntityRequest request) async {
    return await repository.login(request);
  }
}