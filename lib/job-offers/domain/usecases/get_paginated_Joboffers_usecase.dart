// Get Paginated Job Offers Use Case
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/repositories/job_offer_repository.dart';
import '../entities/job_offer.dart';
import '../entities/job_offer_request.dart';

class GetPaginatedJobOffersUseCase {
  final JobOfferRepository repository;

  GetPaginatedJobOffersUseCase(this.repository);

  Future<Either<Failure, JobOfferListResponse>> call({
    int page = 1,
    int perPage = 10,
    String? categoryId,
    String? status,
    String? urgency,
    double? priceMin,
    double? priceMax,
    String? location,
    bool? featuredOnly,
    String? sortBy,
    String? sortOrder,
  }) async {
    if (page < 1) {
      return const Left(ValidationFailure(
        message: 'Invalid page number',
        userFriendlyMessage: 'Page number must be greater than 0.',
      ));
    }

    if (perPage < 1 || perPage > 100) {
      return const Left(ValidationFailure(
        message: 'Invalid per page value',
        userFriendlyMessage: 'Items per page must be between 1 and 100.',
      ));
    }

    if (priceMin != null && priceMin < 0) {
      return const Left(ValidationFailure(
        message: 'Invalid minimum price',
        userFriendlyMessage: 'Minimum price cannot be negative.',
      ));
    }

    if (priceMax != null && priceMax < 0) {
      return const Left(ValidationFailure(
        message: 'Invalid maximum price',
        userFriendlyMessage: 'Maximum price cannot be negative.',
      ));
    }

    if (priceMin != null && priceMax != null && priceMin > priceMax) {
      return const Left(ValidationFailure(
        message: 'Invalid price range',
        userFriendlyMessage: 'Minimum price cannot be greater than maximum price.',
      ));
    }

    final query = JobOfferQuery(
      page: page,
      perPage: perPage,
      categoryId: categoryId,
      status: status,
      urgency: urgency,
      priceMin: priceMin,
      priceMax: priceMax,
      location: location,
      featuredOnly: featuredOnly,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );

    return await repository.getJobOffers(query);
  }}// Validation Failure class (if not already defined in your failures)
class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    String? userFriendlyMessage,
  }) : super(
    message: message,
    userFriendlyMessage: userFriendlyMessage ?? 'Please check your input and try again.',
  );
}