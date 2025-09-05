// lib/data/repositories/job_offer_repository.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../domain/entities/job_offer.dart';
import '../../domain/entities/job_offer_request.dart';

abstract class JobOfferRepository {
  // Get all job offers with optional filtering
  Future<Either<Failure, JobOfferListResponse>> getJobOffers([JobOfferQuery? query]);
  
  // Get a specific job offer by ID
  Future<Either<Failure, JobOffer>> getJobOffer(String id);
  
  // Create a new job offer
  Future<Either<Failure, JobOffer>> createJobOffer(JobOfferRequest request);
  
  // Update an existing job offer (full update)
  Future<Either<Failure, JobOffer>> updateJobOffer(String id, JobOfferRequest request);
  
  // Partial update of a job offer
  Future<Either<Failure, JobOffer>> partialUpdateJobOffer(String id, JobOfferRequest request);
  
  // Delete a job offer
  Future<Either<Failure, void>> deleteJobOffer(String id);
  
  // Publish a job offer
  Future<Either<Failure, JobOffer>> publishJobOffer(String id);
  
  // Cancel a job offer
  Future<Either<Failure, JobOffer>> cancelJobOffer(String id);
  
  // Start a job offer (move to in_progress)
  Future<Either<Failure, JobOffer>> startJobOffer(String id);
  
  // Complete a job offer
  Future<Either<Failure, JobOffer>> completeJobOffer(String id);
  
  // Search job offers
  Future<Either<Failure, JobOfferListResponse>> searchJobOffers({
    required String query,
    String? categoryId,
    String? location,
    double? priceMin,
    double? priceMax,
    String? urgency,
    int page = 1,
    int perPage = 10,
  });
  
  // Get featured job offers
  Future<Either<Failure, JobOfferListResponse>> getFeaturedJobOffers([int? page, int? perPage]);
  
  // Get recent job offers
  Future<Either<Failure, JobOfferListResponse>> getRecentJobOffers([int? page, int? perPage]);
  
  // Get job offers by category
  Future<Either<Failure, JobOfferListResponse>> getJobOffersByCategory(
    String categoryId, [
    int? page,
    int? perPage,
  ]);
  
  // Get job offers by location
  Future<Either<Failure, JobOfferListResponse>> getJobOffersByLocation({
    required double latitude,
    required double longitude,
    double radius = 20.0,
    int? page,
    int? perPage,
  });
  
  // Get user's own job offers
  Future<Either<Failure, JobOfferListResponse>> getMyJobOffers([JobOfferQuery? query]);
  
  // Get user statistics
  Future<Either<Failure, UserStats>> getMyStatistics();
  
  // Get public statistics
  Future<Either<Failure, PublicStats>> getPublicStatistics();
}