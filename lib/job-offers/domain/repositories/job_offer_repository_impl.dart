// lib/data/repositories/job_offer_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/network_info.dart';
import '../../../core/services/cache_manager.dart';
import '../../data/datasources/job_offer_remote_data_source.dart';
import '../../data/repositories/job_offer_repository.dart';
import '../../domain/entities/job_offer.dart';
import '../../domain/entities/job_offer_request.dart';

class JobOfferRepositoryImpl implements JobOfferRepository {
  final JobOfferRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final CacheManager? cacheManager;

  JobOfferRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    this.cacheManager,
  });

  @override
  Future<Either<Failure, JobOfferListResponse>> getJobOffers([JobOfferQuery? query]) async {
    if (!await networkInfo.isConnected) {
      // Try to get cached data if available
      if (cacheManager != null) {
        try {
          final cachedData = await _getCachedJobOffers();
          if (cachedData != null) {
            return Right(cachedData);
          }
        } catch (e) {
          print('Error getting cached job offers: $e');
        }
      }
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getJobOffers(query);
      
      // Cache the response for offline use (only for general queries without specific filters)
      if (cacheManager != null && (query == null || query.isFilterEmpty)) {
        try {
          await _cacheJobOffers(response);
        } catch (e) {
          print('Error caching job offers: $e');
        }
      }
      
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to fetch job offers'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOffer>> getJobOffer(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getJobOffer(id);
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Job offer not found'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOffer>> createJobOffer(JobOfferRequest request) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.createJobOffer(request);
      
      // Clear cache to ensure fresh data on next fetch
      if (cacheManager != null) {
        try {
          await _clearJobOffersCache();
        } catch (e) {
          print('Error clearing job offers cache: $e');
        }
      }
      
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to create job offer'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOffer>> updateJobOffer(String id, JobOfferRequest request) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.updateJobOffer(id, request);
      
      // Clear cache to ensure fresh data on next fetch
      if (cacheManager != null) {
        try {
          await _clearJobOffersCache();
        } catch (e) {
          print('Error clearing job offers cache: $e');
        }
      }
      
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to update job offer'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOffer>> partialUpdateJobOffer(String id, JobOfferRequest request) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.partialUpdateJobOffer(id, request);
      
      // Clear cache to ensure fresh data on next fetch
      if (cacheManager != null) {
        try {
          await _clearJobOffersCache();
        } catch (e) {
          print('Error clearing job offers cache: $e');
        }
      }
      
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to update job offer'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteJobOffer(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.deleteJobOffer(id);
      
      // Clear cache to ensure fresh data on next fetch
      if (cacheManager != null) {
        try {
          await _clearJobOffersCache();
        } catch (e) {
          print('Error clearing job offers cache: $e');
        }
      }
      
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to delete job offer'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOffer>> publishJobOffer(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.publishJobOffer(id);
      
      // Clear cache to ensure fresh data on next fetch
      if (cacheManager != null) {
        try {
          await _clearJobOffersCache();
        } catch (e) {
          print('Error clearing job offers cache: $e');
        }
      }
      
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to publish job offer'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOffer>> cancelJobOffer(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.cancelJobOffer(id);
      
      // Clear cache to ensure fresh data on next fetch
      if (cacheManager != null) {
        try {
          await _clearJobOffersCache();
        } catch (e) {
          print('Error clearing job offers cache: $e');
        }
      }
      
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to cancel job offer'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOffer>> startJobOffer(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.startJobOffer(id);
      
      // Clear cache to ensure fresh data on next fetch
      if (cacheManager != null) {
        try {
          await _clearJobOffersCache();
        } catch (e) {
          print('Error clearing job offers cache: $e');
        }
      }
      
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to start job offer'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOffer>> completeJobOffer(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.completeJobOffer(id);
      
      // Clear cache to ensure fresh data on next fetch
      if (cacheManager != null) {
        try {
          await _clearJobOffersCache();
        } catch (e) {
          print('Error clearing job offers cache: $e');
        }
      }
      
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to complete job offer'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOfferListResponse>> searchJobOffers({
    required String query,
    String? categoryId,
    String? location,
    double? priceMin,
    double? priceMax,
    String? urgency,
    int page = 1,
    int perPage = 10,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final params = <String, dynamic>{
        'query': query,
        'page': page.toString(),
        'per_page': perPage.toString(),
      };
      
      if (categoryId != null) params['category_id'] = categoryId;
      if (location != null) params['location'] = location;
      if (priceMin != null) params['price_min'] = priceMin.toString();
      if (priceMax != null) params['price_max'] = priceMax.toString();
      if (urgency != null) params['urgency'] = urgency;

      final response = await remoteDataSource.searchJobOffers(params);
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to search job offers'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOfferListResponse>> getFeaturedJobOffers([int? page, int? perPage]) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getFeaturedJobOffers(page, perPage);
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to fetch featured job offers'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOfferListResponse>> getRecentJobOffers([int? page, int? perPage]) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getRecentJobOffers(page, perPage);
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to fetch recent job offers'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOfferListResponse>> getJobOffersByCategory(
    String categoryId, [
    int? page,
    int? perPage,
  ]) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getJobOffersByCategory(categoryId, page, perPage);
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to fetch job offers by category'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOfferListResponse>> getJobOffersByLocation({
    required double latitude,
    required double longitude,
    double radius = 20.0,
    int? page,
    int? perPage,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final params = <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius.toString(),
      };
      
      if (page != null) params['page'] = page.toString();
      if (perPage != null) params['per_page'] = perPage.toString();

      final response = await remoteDataSource.getJobOffersByLocation(params);
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to fetch job offers by location'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, JobOfferListResponse>> getMyJobOffers([JobOfferQuery? query]) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getMyJobOffers(query);
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to fetch my job offers'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, UserStats>> getMyStatistics() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getMyStatistics();
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to fetch statistics'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, PublicStats>> getPublicStatistics() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getPublicStatistics();
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Failed to fetch public statistics'));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  // Private helper methods
  ServerFailure _handleDioException(DioException e, String defaultMessage) {
    final statusCode = e.response?.statusCode ?? 0;
    String errorMessage = defaultMessage;
    String? userFriendlyMessage;

    // Extract error message from response
    if (e.response?.data != null) {
      final responseData = e.response!.data;
      if (responseData is Map<String, dynamic>) {
        errorMessage = responseData['message'] ?? defaultMessage;
      }
    } else if (e.message != null) {
      errorMessage = e.message!;
    }

    // Provide user-friendly messages based on status codes
    switch (statusCode) {
      case 400:
        userFriendlyMessage = 'Invalid request. Please check your input and try again.';
        break;
      case 401:
        userFriendlyMessage = 'You are not authorized. Please log in again.';
        break;
      case 403:
        userFriendlyMessage = 'You do not have permission to perform this action.';
        break;
      case 404:
        userFriendlyMessage = 'The requested resource was not found.';
        break;
      case 409:
        userFriendlyMessage = 'A conflict occurred. The resource may have been modified.';
        break;
      case 422:
        userFriendlyMessage = 'Please check your input data and try again.';
        break;
      case 429:
        userFriendlyMessage = 'Too many requests. Please try again later.';
        break;
      case 500:
      case 502:
      case 503:
        userFriendlyMessage = 'Server error. Please try again later.';
        break;
      default:
        if (e.type == DioExceptionType.connectionTimeout) {
          userFriendlyMessage = 'Connection timeout. Please check your internet connection.';
        } else if (e.type == DioExceptionType.receiveTimeout) {
          userFriendlyMessage = 'Request timeout. Please try again.';
        } else if (e.type == DioExceptionType.connectionError) {
          userFriendlyMessage = 'Connection error. Please check your internet connection.';
        } else {
          userFriendlyMessage = 'An unexpected error occurred. Please try again.';
        }
    }

    return ServerFailure(
      message: errorMessage,
      statusCode: statusCode,
      userFriendlyMessage: userFriendlyMessage,
    );
  }

  // Private cache methods
  static const String _cacheKey = 'job_offers_cache';
  static const Duration _cacheExpiry = Duration(hours: 1);

  Future<JobOfferListResponse?> _getCachedJobOffers() async {
    if (cacheManager == null) return null;
    
    try {
      final cachedData = await cacheManager!.getCachedData(_cacheKey);
      if (cachedData != null) {
        return JobOfferListResponse.fromJson(cachedData);
      }
    } catch (e) {
      print('Error getting cached job offers: $e');
    }
    return null;
  }

  Future<void> _cacheJobOffers(JobOfferListResponse response) async {
    if (cacheManager == null) return;
    
    try {
      await cacheManager!.cacheData(
        _cacheKey,
        response.toJson(),
        expiry: _cacheExpiry,
      );
    } catch (e) {
      print('Error caching job offers: $e');
    }
  }

  Future<void> _clearJobOffersCache() async {
    if (cacheManager == null) return;
    
    try {
      await cacheManager!.clearCache(_cacheKey);
    } catch (e) {
      print('Error clearing job offers cache: $e');
    }
  }
}

// Extension method for JobOfferListResponse to support toJson
extension JobOfferListResponseExtension on JobOfferListResponse {
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': {
        'data': data.data.map((e) => e.toJson()).toList(),
        if (data.meta != null)
          'meta': {
            'count': data.meta!.count,
            'draft_count': data.meta!.draftCount,
            'published_count': data.meta!.publishedCount,
            'in_progress_count': data.meta!.inProgressCount,
            'completed_count': data.meta!.completedCount,
            'cancelled_count': data.meta!.cancelledCount,
            'featured_count': data.meta!.featuredCount,
          },
      },
      'meta': {
        'total': meta.total,
        'current_page': meta.currentPage,
        'last_page': meta.lastPage,
        'per_page': meta.perPage,
        'stats': {
          'count': meta.stats.count,
          'draft_count': meta.stats.draftCount,
          'published_count': meta.stats.publishedCount,
          'in_progress_count': meta.stats.inProgressCount,
          'completed_count': meta.stats.completedCount,
          'cancelled_count': meta.stats.cancelledCount,
          'featured_count': meta.stats.featuredCount,
        },
        'filters': {
          if (meta.filters.categoryId != null) 'category_id': meta.filters.categoryId,
          if (meta.filters.status != null) 'status': meta.filters.status,
          if (meta.filters.urgency != null) 'urgency': meta.filters.urgency,
          if (meta.filters.priceMin != null) 'price_min': meta.filters.priceMin,
          if (meta.filters.priceMax != null) 'price_max': meta.filters.priceMax,
          if (meta.filters.location != null) 'location': meta.filters.location,
          if (meta.filters.radius != null) 'radius': meta.filters.radius,
          'featured_only': meta.filters.featuredOnly,
        },
      },
      'status': status,
    };
  }
}