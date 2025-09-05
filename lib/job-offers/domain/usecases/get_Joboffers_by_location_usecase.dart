// Get Job Offers by Location Use Case
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/repositories/job_offer_repository.dart';
import '../entities/job_offer.dart';

class GetJobOffersByLocationUseCase {
  final JobOfferRepository repository;

  GetJobOffersByLocationUseCase(this.repository);

  Future<Either<Failure, JobOfferListResponse>> call({
    required double latitude,
    required double longitude,
    double radius = 20.0,
    int? page,
    int? perPage,
  }) async {
    // Validate latitude
    if (latitude < -90 || latitude > 90) {
      return const Left(ValidationFailure(
        message: 'Invalid latitude',
        userFriendlyMessage: 'Latitude must be between -90 and 90.',
      ));
    }

    // Validate longitude
    if (longitude < -180 || longitude > 180) {
      return const Left(ValidationFailure(
        message: 'Invalid longitude',
        userFriendlyMessage: 'Longitude must be between -180 and 180.',
      ));
    }

    // Validate radius
    if (radius <= 0 || radius > 1000) {
      return const Left(ValidationFailure(
        message: 'Invalid radius',
        userFriendlyMessage: 'Radius must be between 1 and 1000 km.',
      ));
    }

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

    return await repository.getJobOffersByLocation(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
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
