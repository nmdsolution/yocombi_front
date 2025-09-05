// lib/data/repositories/service_category_repository.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_category_request.dart';

abstract class ServiceCategoryRepository {
  // Get all service categories with optional filtering
  Future<Either<Failure, ServiceCategoryListResponse>> getServiceCategories([ServiceCategoryQuery? query]);
  
  // Get a specific service category by ID
  Future<Either<Failure, ServiceCategory>> getServiceCategory(String id);
  
  // Create a new service category
  Future<Either<Failure, ServiceCategory>> createServiceCategory(ServiceCategoryRequest request);
  
  // Update an existing service category
  Future<Either<Failure, ServiceCategory>> updateServiceCategory(String id, ServiceCategoryRequest request);
  
  // Delete a service category
  Future<Either<Failure, void>> deleteServiceCategory(String id);
  
  // Toggle active status of a service category
  Future<Either<Failure, ServiceCategory>> toggleServiceCategoryStatus(String id);
  
  // Get active service categories only (cached)
  Future<Either<Failure, List<ServiceCategory>>> getActiveServiceCategories();
}