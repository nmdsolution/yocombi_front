// Get My Statistics Use Case
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/repositories/job_offer_repository.dart';
import '../entities/job_offer.dart';
import '../entities/job_offer_request.dart';


class GetMyStatisticsUseCase {
  final JobOfferRepository repository;

  GetMyStatisticsUseCase(this.repository);

  Future<Either<Failure, UserStats>> call() async {
    return await repository.getMyStatistics();
  }
}
