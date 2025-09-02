// lib/presentation/providers/service_category_provider.dart
import 'package:flutter/foundation.dart';
import '../domain/entities/service_category.dart';
import '../domain/entities/service_category_request.dart';
import '../data/repositories/service_category_repository.dart';
import '../../core/errors/failures.dart';

enum ServiceCategoryState {
  initial,
  loading,
  success,
  error,
}

class ServiceCategoryProvider extends ChangeNotifier {
  final ServiceCategoryRepository _repository;

  ServiceCategoryProvider(this._repository);

  // State management
  ServiceCategoryState _state = ServiceCategoryState.initial;
  ServiceCategoryState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Data
  List<ServiceCategory> _serviceCategories = [];
  List<ServiceCategory> get serviceCategories => List.unmodifiable(_serviceCategories);

  List<ServiceCategory> _activeServiceCategories = [];
  List<ServiceCategory> get activeServiceCategories => List.unmodifiable(_activeServiceCategories);

  ServiceCategory? _selectedServiceCategory;
  ServiceCategory? get selectedServiceCategory => _selectedServiceCategory;

  ServiceCategoryListResponse? _lastResponse;
  ServiceCategoryListResponse? get lastResponse => _lastResponse;

  // Statistics
  int get totalCount => _lastResponse?.meta.total ?? 0;
  int get activeCount => _lastResponse?.meta.stats.activeCount ?? 0;
  int get inactiveCount => _lastResponse?.meta.stats.inactiveCount ?? 0;

  // Loading states for individual operations
  bool _isCreating = false;
  bool get isCreating => _isCreating;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  bool _isToggling = false;
  bool get isToggling => _isToggling;

  // Get all service categories with optional query
  Future<void> getServiceCategories([ServiceCategoryQuery? query]) async {
    _setState(ServiceCategoryState.loading);

    final result = await _repository.getServiceCategories(query);

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (response) {
        _lastResponse = response;
        _serviceCategories = response.data.data;
        _activeServiceCategories = _serviceCategories.where((cat) => cat.isActive).toList();
        _setState(ServiceCategoryState.success);
      },
    );
  }

  // Get active service categories only
  Future<void> getActiveServiceCategories() async {
    _setState(ServiceCategoryState.loading);

    final result = await _repository.getActiveServiceCategories();

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (categories) {
        _activeServiceCategories = categories;
        _setState(ServiceCategoryState.success);
      },
    );
  }

  // Get a single service category
  Future<void> getServiceCategory(String id) async {
    _setState(ServiceCategoryState.loading);

    final result = await _repository.getServiceCategory(id);

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (category) {
        _selectedServiceCategory = category;
        _setState(ServiceCategoryState.success);
      },
    );
  }

  // Create a new service category
  Future<bool> createServiceCategory(ServiceCategoryRequest request) async {
    if (!request.isValidForCreate) {
      _setError('Invalid service category data. Please check all required fields.');
      return false;
    }

    _isCreating = true;
    notifyListeners();

    final result = await _repository.createServiceCategory(request);

    _isCreating = false;

    return result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
        return false;
      },
      (category) {
        // Add to local list and refresh
        _serviceCategories.add(category);
        if (category.isActive) {
          _activeServiceCategories.add(category);
        }
        _setState(ServiceCategoryState.success);
        return true;
      },
    );
  }

  // Update an existing service category
  Future<bool> updateServiceCategory(String id, ServiceCategoryRequest request) async {
    if (!request.isValidForUpdate) {
      _setError('Invalid update data. At least one field must be provided.');
      return false;
    }

    _isUpdating = true;
    notifyListeners();

    final result = await _repository.updateServiceCategory(id, request);

    _isUpdating = false;

    return result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
        return false;
      },
      (updatedCategory) {
        // Update in local lists
        _updateCategoryInLists(updatedCategory);
        _selectedServiceCategory = updatedCategory;
        _setState(ServiceCategoryState.success);
        return true;
      },
    );
  }

  // Delete a service category
  Future<bool> deleteServiceCategory(String id) async {
    _isDeleting = true;
    notifyListeners();

    final result = await _repository.deleteServiceCategory(id);

    _isDeleting = false;

    return result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
        return false;
      },
      (_) {
        // Remove from local lists
        _serviceCategories.removeWhere((cat) => cat.id == id);
        _activeServiceCategories.removeWhere((cat) => cat.id == id);
        
        // Clear selected if it was deleted
        if (_selectedServiceCategory?.id == id) {
          _selectedServiceCategory = null;
        }
        
        _setState(ServiceCategoryState.success);
        return true;
      },
    );
  }

  // Toggle service category status
  Future<bool> toggleServiceCategoryStatus(String id) async {
    _isToggling = true;
    notifyListeners();

    final result = await _repository.toggleServiceCategoryStatus(id);

    _isToggling = false;

    return result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
        return false;
      },
      (updatedCategory) {
        // Update in local lists
        _updateCategoryInLists(updatedCategory);
        _selectedServiceCategory = updatedCategory;
        _setState(ServiceCategoryState.success);
        return true;
      },
    );
  }

  // Search service categories by name
  List<ServiceCategory> searchServiceCategories(String query) {
    if (query.isEmpty) return _serviceCategories;
    
    final lowerQuery = query.toLowerCase();
    return _serviceCategories.where((category) {
      return category.name.toLowerCase().contains(lowerQuery) ||
             category.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Filter service categories by status
  List<ServiceCategory> filterServiceCategories({bool? isActive}) {
    if (isActive == null) return _serviceCategories;
    return _serviceCategories.where((cat) => cat.isActive == isActive).toList();
  }

  // Sort service categories
  List<ServiceCategory> sortServiceCategories({
    String sortBy = 'sort_order',
    bool ascending = true,
  }) {
    final categories = List<ServiceCategory>.from(_serviceCategories);
    
    categories.sort((a, b) {
      int comparison;
      switch (sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'created_at':
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case 'updated_at':
          comparison = a.updatedAt.compareTo(b.updatedAt);
          break;
        case 'sort_order':
        default:
          comparison = a.sortOrder.compareTo(b.sortOrder);
          break;
      }
      return ascending ? comparison : -comparison;
    });
    
    return categories;
  }

  // Get category by ID
  ServiceCategory? getCategoryById(String id) {
    try {
      return _serviceCategories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear all data
  void clearData() {
    _serviceCategories.clear();
    _activeServiceCategories.clear();
    _selectedServiceCategory = null;
    _lastResponse = null;
    _setState(ServiceCategoryState.initial);
  }

  // Clear error
  void clearError() {
    _errorMessage = '';
    if (_state == ServiceCategoryState.error) {
      _setState(ServiceCategoryState.initial);
    }
  }

  // Private helper methods
  void _setState(ServiceCategoryState newState) {
    _state = newState;
    if (newState != ServiceCategoryState.error) {
      _errorMessage = '';
    }
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setState(ServiceCategoryState.error);
  }

  void _updateCategoryInLists(ServiceCategory updatedCategory) {
    // Update in main list
    final index = _serviceCategories.indexWhere((cat) => cat.id == updatedCategory.id);
    if (index != -1) {
      _serviceCategories[index] = updatedCategory;
    }

    // Update active categories list
    _activeServiceCategories.removeWhere((cat) => cat.id == updatedCategory.id);
    if (updatedCategory.isActive) {
      _activeServiceCategories.add(updatedCategory);
      // Sort active categories by sort_order
      _activeServiceCategories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }
  }

  String _getErrorMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.userFriendlyMessage ?? failure.message;
    } else if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network and try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Utility getters
  bool get hasData => _serviceCategories.isNotEmpty;
  bool get hasActiveCategories => _activeServiceCategories.isNotEmpty;
  bool get isLoading => _state == ServiceCategoryState.loading;
  bool get hasError => _state == ServiceCategoryState.error;
  bool get isSuccess => _state == ServiceCategoryState.success;

  // Check if any operation is in progress
  bool get isOperationInProgress => 
      isLoading || _isCreating || _isUpdating || _isDeleting || _isToggling;
}