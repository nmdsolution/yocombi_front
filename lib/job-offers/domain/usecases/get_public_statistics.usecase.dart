
// Get Public Statistics Use Case
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/repositories/job_offer_repository.dart';
import '../entities/job_offer.dart';

class GetPublicStatisticsUseCase {
  final JobOfferRepository repository;

  GetPublicStatisticsUseCase(this.repository);

  Future<Either<Failure, PublicStats>> call() async {
    return await repository.getPublicStatistics();
  }
}
