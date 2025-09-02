
// Cancel Job Offer Use Case
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/repositories/job_offer_repository.dart';
import '../entities/job_offer.dart';


class CancelJobOfferUseCase {
  final JobOfferRepository repository;

  CancelJobOfferUseCase(this.repository);

  Future<Either<Failure, JobOffer>> call(String id) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Invalid job offer ID',
        userFriendlyMessage: 'Job offer ID cannot be empty.',
      ));
    }
    
    return await repository.cancelJobOffer(id);
  }
  
}
// Validation Failure class (if not already defined in your failures)
class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    String? userFriendlyMessage,
  }) : super(
    message: message,
    userFriendlyMessage: userFriendlyMessage ?? 'Please check your input and try again.',
  );}