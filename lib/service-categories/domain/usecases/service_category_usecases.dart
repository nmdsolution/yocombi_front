// lib/domain/usecases/service_category_usecases.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../data/repositories/service_category_repository.dart';
import '../entities/service_category.dart';
import '../entities/service_category_request.dart';

// Get Service Categories Use Case
class GetServiceCategoriesUseCase {
  final ServiceCategoryRepository repository;

  GetServiceCategoriesUseCase(this.repository);

  Future<Either<Failure, ServiceCategoryListResponse>> call([ServiceCategoryQuery? query]) async {
    return await repository.getServiceCategories(query);
  }
}

// Get Service Category Use Case
class GetServiceCategoryUseCase {
  final ServiceCategoryRepository repository;

  GetServiceCategoryUseCase(this.repository);

  Future<Either<Failure, ServiceCategory>> call(String id) async {
    return await repository.getServiceCategory(id);
  }
}

// Create Service Category Use Case
class CreateServiceCategoryUseCase {
  final ServiceCategoryRepository repository;

  CreateServiceCategoryUseCase(this.repository);

  Future<Either<Failure, ServiceCategory>> call(ServiceCategoryRequest request) async {
    if (!request.isValidForCreate) {
      return const Left(ValidationFailure(
        message: 'Invalid service category data',
        userFriendlyMessage: 'Please provide all required fields: name, description, and icon.',
      ));
    }
    
    return await repository.createServiceCategory(request);
  }
}

// Update Service Category Use Case
class UpdateServiceCategoryUseCase {
  final ServiceCategoryRepository repository;

  UpdateServiceCategoryUseCase(this.repository);

  Future<Either<Failure, ServiceCategory>> call(String id, ServiceCategoryRequest request) async {
    if (!request.isValidForUpdate) {
      return const Left(ValidationFailure(
        message: 'No valid data provided for update',
        userFriendlyMessage: 'Please provide at least one field to update.',
      ));
    }
    
    return await repository.updateServiceCategory(id, request);
  }
}

// Delete Service Category Use Case
class DeleteServiceCategoryUseCase {
  final ServiceCategoryRepository repository;

  DeleteServiceCategoryUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Invalid service category ID',
        userFriendlyMessage: 'Service category ID cannot be empty.',
      ));
    }
    
    return await repository.deleteServiceCategory(id);
  }
}

// Toggle Service Category Status Use Case
class ToggleServiceCategoryStatusUseCase {
  final ServiceCategoryRepository repository;

  ToggleServiceCategoryStatusUseCase(this.repository);

  Future<Either<Failure, ServiceCategory>> call(String id) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Invalid service category ID',
        userFriendlyMessage: 'Service category ID cannot be empty.',
      ));
    }
    
    return await repository.toggleServiceCategoryStatus(id);
  }
}

// Get Active Service Categories Use Case
class GetActiveServiceCategoriesUseCase {
  final ServiceCategoryRepository repository;

  GetActiveServiceCategoriesUseCase(this.repository);

  Future<Either<Failure, List<ServiceCategory>>> call() async {
    return await repository.getActiveServiceCategories();
  }
}

// Search Service Categories Use Case
class SearchServiceCategoriesUseCase {
  final ServiceCategoryRepository repository;

  SearchServiceCategoriesUseCase(this.repository);

  Future<Either<Failure, ServiceCategoryListResponse>> call({
    required String searchTerm,
    bool activeOnly = true,
    int page = 1,
    int perPage = 10,
  }) async {
    if (searchTerm.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Search term cannot be empty',
        userFriendlyMessage: 'Please enter a search term.',
      ));
    }

    final query = ServiceCategoryQuery.paginated(
      search: searchTerm.trim(),
      activeOnly: activeOnly,
      page: page,
      perPage: perPage,
    );

    return await repository.getServiceCategories(query);
  }
}

// Get Paginated Service Categories Use Case
class GetPaginatedServiceCategoriesUseCase {
  final ServiceCategoryRepository repository;

  GetPaginatedServiceCategoriesUseCase(this.repository);

  Future<Either<Failure, ServiceCategoryListResponse>> call({
    int page = 1,
    int perPage = 10,
    bool? activeOnly,
    bool ordered = true,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) async {
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

    final query = ServiceCategoryQuery(
      page: page,
      perPage: perPage,
      activeOnly: activeOnly,
      ordered: ordered,
      search: search?.trim(),
      sortBy: sortBy,
      sortOrder: sortOrder,
    );

    return await repository.getServiceCategories(query);
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