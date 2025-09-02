
// Get My Job Offers Use Case
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/repositories/job_offer_repository.dart';
import '../entities/job_offer.dart';
import '../entities/job_offer_request.dart';

class GetMyJobOffersUseCase {
  final JobOfferRepository repository;

  GetMyJobOffersUseCase(this.repository);

  Future<Either<Failure, JobOfferListResponse>> call([JobOfferQuery? query]) async {
    return await repository.getMyJobOffers(query);
  }
}
