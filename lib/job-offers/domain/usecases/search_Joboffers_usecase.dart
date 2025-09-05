// Search Job Offers Use Case
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/repositories/job_offer_repository.dart';
import '../entities/job_offer.dart';

class SearchJobOffersUseCase {
  final JobOfferRepository repository;

  SearchJobOffersUseCase(this.repository);

  Future<Either<Failure, JobOfferListResponse>> call({
    required String searchTerm,
    String? categoryId,
    String? location,
    double? priceMin,
    double? priceMax,
    String? urgency,
    int page = 1,
    int perPage = 10,
  }) async {
    if (searchTerm.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Search term cannot be empty',
        userFriendlyMessage: 'Please enter a search term.',
      ));
    }

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

    return await repository.searchJobOffers(
      query: searchTerm.trim(),
      categoryId: categoryId,
      location: location,
      priceMin: priceMin,
      priceMax: priceMax,
      urgency: urgency,
      page: page,
      perPage: perPage,
    );
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