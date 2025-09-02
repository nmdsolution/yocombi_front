// Partial Update Job Offer Use Case
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/repositories/job_offer_repository.dart';
import '../entities/job_offer.dart';
import '../entities/job_offer_request.dart';

class PartialUpdateJobOfferUseCase {
  final JobOfferRepository repository;

  PartialUpdateJobOfferUseCase(this.repository);

  Future<Either<Failure, JobOffer>> call(String id, JobOfferRequest request) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Invalid job offer ID',
        userFriendlyMessage: 'Job offer ID cannot be empty.',
      ));
    }

    if (!request.isValidForPartialUpdate) {
      return const Left(ValidationFailure(
        message: 'No valid data provided for update',
        userFriendlyMessage: 'Please provide at least one field to update.',
      ));
    }
    
    // Additional business validations
    if (request.deadline != null && request.deadline!.isBefore(DateTime.now())) {
      return const Left(ValidationFailure(
        message: 'Invalid deadline',
        userFriendlyMessage: 'Deadline must be in the future.',
      ));
    }

    if (request.estimatedPrice != null && request.estimatedPrice! <= 0) {
      return const Left(ValidationFailure(
        message: 'Invalid price',
        userFriendlyMessage: 'Price must be greater than 0.',
      ));
    }
    
    return await repository.partialUpdateJobOffer(id, request);
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
  );
}