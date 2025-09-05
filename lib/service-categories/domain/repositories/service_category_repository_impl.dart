// lib/data/repositories/service_category_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../core/errors/error_messages.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/network_info.dart';
import '../../../core/services/cache_manager.dart';
import '../../data/datasources/service_category_remote_data_source.dart';
import '../../data/repositories/service_category_repository.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_category_request.dart';


class ServiceCategoryRepositoryImpl implements ServiceCategoryRepository {
  final ServiceCategoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final CacheManager? cacheManager;

  ServiceCategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    this.cacheManager,
  });

  @override
  Future<Either<Failure, ServiceCategoryListResponse>> getServiceCategories([ServiceCategoryQuery? query]) async {
    if (!await networkInfo.isConnected) {
      // Try to get cached data if available
      if (cacheManager != null) {
        try {
          final cachedData = await _getCachedServiceCategories();
          if (cachedData != null) {
            return Right(cachedData);
          }
        } catch (e) {
          print('Error getting cached service categories: $e');
        }
      }
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getServiceCategories(query);
      
      // Cache the response for offline use
      if (cacheManager != null && query?.activeOnly == true) {
        try {
          await _cacheServiceCategories(response);
        } catch (e) {
          print('Error caching service categories: $e');
        }
      }
      
      return Right(response);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final errorMessage = e.message ?? 'Failed to fetch service categories';

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: statusCode,
        userFriendlyMessage:
            ErrorMessageHandler.getFriendlyMessage(statusCode: statusCode),
      ));
    } on http.ClientException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 0,
        userFriendlyMessage: 'Connection error. Please try again.',
      ));
    } on FormatException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 400,
        userFriendlyMessage: 'Invalid server response format.',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, ServiceCategory>> getServiceCategory(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getServiceCategory(id);
      return Right(response);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final errorMessage = e.message ?? 'Service category not found';

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: statusCode,
        userFriendlyMessage:
            ErrorMessageHandler.getFriendlyMessage(statusCode: statusCode),
      ));
    } on http.ClientException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 0,
        userFriendlyMessage: 'Connection error. Please try again.',
      ));
    } on FormatException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 400,
        userFriendlyMessage: 'Invalid server response format.',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, ServiceCategory>> createServiceCategory(ServiceCategoryRequest request) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.createServiceCategory(request);
      
      // Clear cache to ensure fresh data on next fetch
      if (cacheManager != null) {
        try {
          await _clearServiceCategoriesCache();
        } catch (e) {
          print('Error clearing service categories cache: $e');
        }
      }
      
      return Right(response);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final errorMessage = e.message ?? 'Failed to create service category';

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: statusCode,
        userFriendlyMessage:
            ErrorMessageHandler.getFriendlyMessage(statusCode: statusCode),
      ));
    } on http.ClientException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 0,
        userFriendlyMessage: 'Connection error. Please try again.',
      ));
    } on FormatException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 400,
        userFriendlyMessage: 'Invalid server response format.',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, ServiceCategory>> updateServiceCategory(String id, ServiceCategoryRequest request) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.updateServiceCategory(id, request);
      
      // Clear cache to ensure fresh data on next fetch
      if (cacheManager != null) {
        try {
          await _clearServiceCategoriesCache();
        } catch (e) {
          print('Error clearing service categories cache: $e');
        }
      }
      
      return Right(response);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final errorMessage = e.message ?? 'Failed to update service category';

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: statusCode,
        userFriendlyMessage:
            ErrorMessageHandler.getFriendlyMessage(statusCode: statusCode),
      ));
    } on http.ClientException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 0,
        userFriendlyMessage: 'Connection error. Please try again.',
      ));
    } on FormatException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 400,
        userFriendlyMessage: 'Invalid server response format.',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteServiceCategory(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.deleteServiceCategory(id);
      
      // Clear cache to ensure fresh data on next fetch
      if (cacheManager != null) {
        try {
          await _clearServiceCategoriesCache();
        } catch (e) {
          print('Error clearing service categories cache: $e');
        }
      }
      
      return const Right(null);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final errorMessage = e.message ?? 'Failed to delete service category';

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: statusCode,
        userFriendlyMessage:
            ErrorMessageHandler.getFriendlyMessage(statusCode: statusCode),
      ));
    } on http.ClientException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 0,
        userFriendlyMessage: 'Connection error. Please try again.',
      ));
    } on FormatException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 400,
        userFriendlyMessage: 'Invalid server response format.',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, ServiceCategory>> toggleServiceCategoryStatus(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.toggleServiceCategoryStatus(id);
      
      // Clear cache to ensure fresh data on next fetch
      if (cacheManager != null) {
        try {
          await _clearServiceCategoriesCache();
        } catch (e) {
          print('Error clearing service categories cache: $e');
        }
      }
      
      return Right(response);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final errorMessage = e.message ?? 'Failed to toggle service category status';

      return Left(ServerFailure(
        message: errorMessage,
        statusCode: statusCode,
        userFriendlyMessage:
            ErrorMessageHandler.getFriendlyMessage(statusCode: statusCode),
      ));
    } on http.ClientException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 0,
        userFriendlyMessage: 'Connection error. Please try again.',
      ));
    } on FormatException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: 400,
        userFriendlyMessage: 'Invalid server response format.',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        statusCode: 500,
        userFriendlyMessage: 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, List<ServiceCategory>>> getActiveServiceCategories() async {
    final query = ServiceCategoryQuery.activeOnly();
    final result = await getServiceCategories(query);
    
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data.data),
    );
  }

  // Private cache methods
  static const String _cacheKey = 'service_categories_cache';
  static const Duration _cacheExpiry = Duration(hours: 1);

  Future<ServiceCategoryListResponse?> _getCachedServiceCategories() async {
    if (cacheManager == null) return null;
    
    try {
      final cachedData = await cacheManager!.getCachedData(_cacheKey);
      if (cachedData != null) {
        return ServiceCategoryListResponse.fromJson(cachedData);
      }
    } catch (e) {
      print('Error getting cached service categories: $e');
    }
    return null;
  }

  Future<void> _cacheServiceCategories(ServiceCategoryListResponse response) async {
    if (cacheManager == null) return;
    
    try {
      await cacheManager!.cacheData(
        _cacheKey,
        response.toJson(),
        expiry: _cacheExpiry,
      );
    } catch (e) {
      print('Error caching service categories: $e');
    }
  }

  Future<void> _clearServiceCategoriesCache() async {
    if (cacheManager == null) return;
    
    try {
      await cacheManager!.clearCache(_cacheKey);
    } catch (e) {
      print('Error clearing service categories cache: $e');
    }
  }
}

// Extension method for ServiceCategoryListResponse to support toJson
extension ServiceCategoryListResponseExtension on ServiceCategoryListResponse {
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': {
        'data': data.data.map((e) => e.toJson()).toList(),
        'meta': {
          'count': data.meta.count,
          'active_count': data.meta.activeCount,
          'inactive_count': data.meta.inactiveCount,
        },
      },
      'meta': {
        'total': meta.total,
        'stats': {
          'total': meta.stats.count,
          'active': meta.stats.activeCount,
          'inactive': meta.stats.inactiveCount,
        },
        'filters': {
          'active_only': meta.filters.activeOnly,
          'ordered': meta.filters.ordered,
        },
      },
      'status': status,
    };
  }
}