// Get Featured Job Offers Use Case
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/repositories/job_offer_repository.dart';
import '../entities/job_offer.dart';

class GetFeaturedJobOffersUseCase {
  final JobOfferRepository repository;

  GetFeaturedJobOffersUseCase(this.repository);

  Future<Either<Failure, JobOfferListResponse>> call([int? page, int? perPage]) async {
    if (page != null && page < 1) {
      return const Left(ValidationFailure(
        message: 'Invalid page number',
        userFriendlyMessage: 'Page number must be greater than 0.',
      ));
    }

    if (perPage != null && (perPage < 1 || perPage > 100)) {
      return const Left(ValidationFailure(
        message: 'Invalid per page value',
        userFriendlyMessage: 'Items per page must be between 1 and 100.',
      ));
    }

    return await repository.getFeaturedJobOffers(page, perPage);
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