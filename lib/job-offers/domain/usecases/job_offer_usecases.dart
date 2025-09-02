// lib/domain/usecases/job_offer_usecases.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../data/repositories/job_offer_repository.dart';
import '../entities/job_offer.dart';
import '../entities/job_offer_request.dart';

// Get Job Offers Use Case
class GetJobOffersUseCase {
  final JobOfferRepository repository;

  GetJobOffersUseCase(this.repository);

  Future<Either<Failure, JobOfferListResponse>> call([JobOfferQuery? query]) async {
    return await repository.getJobOffers(query);
  }
}