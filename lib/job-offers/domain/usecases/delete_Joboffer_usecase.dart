// Delete Job Offer Use Case
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/repositories/job_offer_repository.dart';

class DeleteJobOfferUseCase {
  final JobOfferRepository repository;

  DeleteJobOfferUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Invalid job offer ID',
        userFriendlyMessage: 'Job offer ID cannot be empty.',
      ));
    }
    
    return await repository.deleteJobOffer(id);
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