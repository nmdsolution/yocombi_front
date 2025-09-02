// lib/presentation/providers/job_offer_provider.dart
import 'package:flutter/foundation.dart';
import '../domain/entities/job_offer.dart';
import '../domain/entities/job_offer_request.dart';
import '../data/repositories/job_offer_repository.dart';
import '../../core/errors/failures.dart';

enum JobOfferState {
  initial,
  loading,
  success,
  error,
}

class JobOfferProvider extends ChangeNotifier {
  final JobOfferRepository _repository;

  JobOfferProvider(this._repository);

  // State management
  JobOfferState _state = JobOfferState.initial;
  JobOfferState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Data
  List<JobOffer> _jobOffers = [];
  List<JobOffer> get jobOffers => List.unmodifiable(_jobOffers);

  List<JobOffer> _featuredJobOffers = [];
  List<JobOffer> get featuredJobOffers => List.unmodifiable(_featuredJobOffers);

  List<JobOffer> _recentJobOffers = [];
  List<JobOffer> get recentJobOffers => List.unmodifiable(_recentJobOffers);

  List<JobOffer> _myJobOffers = [];
  List<JobOffer> get myJobOffers => List.unmodifiable(_myJobOffers);

  JobOffer? _selectedJobOffer;
  JobOffer? get selectedJobOffer => _selectedJobOffer;

  JobOfferListResponse? _lastResponse;
  JobOfferListResponse? get lastResponse => _lastResponse;

  UserStats? _myStats;
  UserStats? get myStats => _myStats;

  PublicStats? _publicStats;
  PublicStats? get publicStats => _publicStats;

  // Pagination
  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  int _totalCount = 0;
  int get totalCount => _totalCount;

  bool get hasNextPage => _currentPage < _totalPages;
  bool get hasPreviousPage => _currentPage > 1;

  // Statistics
  int get draftCount => _lastResponse?.meta.stats.draftCount ?? 0;
  int get publishedCount => _lastResponse?.meta.stats.publishedCount ?? 0;
  int get inProgressCount => _lastResponse?.meta.stats.inProgressCount ?? 0;
  int get completedCount => _lastResponse?.meta.stats.completedCount ?? 0;
  int get cancelledCount => _lastResponse?.meta.stats.cancelledCount ?? 0;
  int get featuredCount => _lastResponse?.meta.stats.featuredCount ?? 0;

  // Loading states for individual operations
  bool _isCreating = false;
  bool get isCreating => _isCreating;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  bool _isPublishing = false;
  bool get isPublishing => _isPublishing;

  bool _isCancelling = false;
  bool get isCancelling => _isCancelling;

  bool _isStarting = false;
  bool get isStarting => _isStarting;

  bool _isCompleting = false;
  bool get isCompleting => _isCompleting;

  // Get all job offers with optional query
  Future<void> getJobOffers([JobOfferQuery? query]) async {
    _setState(JobOfferState.loading);

    final result = await _repository.getJobOffers(query);

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (response) {
        _lastResponse = response;
        _jobOffers = response.data.data;
        _currentPage = response.meta.currentPage;
        _totalPages = response.meta.lastPage;
        _totalCount = response.meta.total;
        _setState(JobOfferState.success);
      },
    );
  }

  // Get a single job offer
  Future<void> getJobOffer(String id) async {
    _setState(JobOfferState.loading);

    final result = await _repository.getJobOffer(id);

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (jobOffer) {
        _selectedJobOffer = jobOffer;
        _setState(JobOfferState.success);
      },
    );
  }

  // Create a new job offer
  Future<bool> createJobOffer(JobOfferRequest request) async {
    if (!request.isValidForCreate) {
      _setError('Invalid job offer data. Please check all required fields.');
      return false;
    }

    _isCreating = true;
    notifyListeners();

    final result = await _repository.createJobOffer(request);

    _isCreating = false;

    return result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
        return false;
      },
      (jobOffer) {
        // Add to local list and refresh
        _jobOffers.insert(0, jobOffer);
        _myJobOffers.insert(0, jobOffer);
        _setState(JobOfferState.success);
        return true;
      },
    );
  }

  // Update an existing job offer
  Future<bool> updateJobOffer(String id, JobOfferRequest request) async {
    if (!request.isValidForUpdate) {
      _setError('Invalid update data. At least one field must be provided.');
      return false;
    }

    _isUpdating = true;
    notifyListeners();

    final result = await _repository.updateJobOffer(id, request);

    _isUpdating = false;

    return result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
        return false;
      },
      (updatedJobOffer) {
        // Update in local lists
        _updateJobOfferInLists(updatedJobOffer);
        _selectedJobOffer = updatedJobOffer;
        _setState(JobOfferState.success);
        return true;
      },
    );
  }

  // Partial update of a job offer
  Future<bool> partialUpdateJobOffer(String id, JobOfferRequest request) async {
    if (!request.isValidForPartialUpdate) {
      _setError('Invalid update data. At least one field must be provided.');
      return false;
    }

    _isUpdating = true;
    notifyListeners();

    final result = await _repository.partialUpdateJobOffer(id, request);

    _isUpdating = false;

    return result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
        return false;
      },
      (updatedJobOffer) {
        // Update in local lists
        _updateJobOfferInLists(updatedJobOffer);
        _selectedJobOffer = updatedJobOffer;
        _setState(JobOfferState.success);
        return true;
      },
    );
  }

  // Delete a job offer
  Future<bool> deleteJobOffer(String id) async {
    _isDeleting = true;
    notifyListeners();

    final result = await _repository.deleteJobOffer(id);

    _isDeleting = false;

    return result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
        return false;
      },
      (_) {
        // Remove from local lists
        _jobOffers.removeWhere((job) => job.id == id);
        _myJobOffers.removeWhere((job) => job.id == id);
        _featuredJobOffers.removeWhere((job) => job.id == id);
        _recentJobOffers.removeWhere((job) => job.id == id);
        
        // Clear selected if it was deleted
        if (_selectedJobOffer?.id == id) {
          _selectedJobOffer = null;
        }
        
        _setState(JobOfferState.success);
        return true;
      },
    );
  }

  // Publish job offer
  Future<bool> publishJobOffer(String id) async {
    _isPublishing = true;
    notifyListeners();

    final result = await _repository.publishJobOffer(id);

    _isPublishing = false;

    return result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
        return false;
      },
      (updatedJobOffer) {
        // Update in local lists
        _updateJobOfferInLists(updatedJobOffer);
        _selectedJobOffer = updatedJobOffer;
        _setState(JobOfferState.success);
        return true;
      },
    );
  }

  // Cancel job offer
  Future<bool> cancelJobOffer(String id) async {
    _isCancelling = true;
    notifyListeners();

    final result = await _repository.cancelJobOffer(id);

    _isCancelling = false;

    return result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
        return false;
      },
      (updatedJobOffer) {
        // Update in local lists
        _updateJobOfferInLists(updatedJobOffer);
        _selectedJobOffer = updatedJobOffer;
        _setState(JobOfferState.success);
        return true;
      },
    );
  }

  // Start job offer
  Future<bool> startJobOffer(String id) async {
    _isStarting = true;
    notifyListeners();

    final result = await _repository.startJobOffer(id);

    _isStarting = false;

    return result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
        return false;
      },
      (updatedJobOffer) {
        // Update in local lists
        _updateJobOfferInLists(updatedJobOffer);
        _selectedJobOffer = updatedJobOffer;
        _setState(JobOfferState.success);
        return true;
      },
    );
  }

  // Complete job offer
  Future<bool> completeJobOffer(String id) async {
    _isCompleting = true;
    notifyListeners();

    final result = await _repository.completeJobOffer(id);

    _isCompleting = false;

    return result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
        return false;
      },
      (updatedJobOffer) {
        // Update in local lists
        _updateJobOfferInLists(updatedJobOffer);
        _selectedJobOffer = updatedJobOffer;
        _setState(JobOfferState.success);
        return true;
      },
    );
  }

  // Search job offers
  Future<void> searchJobOffers({
    required String query,
    String? categoryId,
    String? location,
    double? priceMin,
    double? priceMax,
    String? urgency,
    int page = 1,
    int perPage = 10,
  }) async {
    _setState(JobOfferState.loading);

    final result = await _repository.searchJobOffers(
      query: query,
      categoryId: categoryId,
      location: location,
      priceMin: priceMin,
      priceMax: priceMax,
      urgency: urgency,
      page: page,
      perPage: perPage,
    );

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (response) {
        _lastResponse = response;
        _jobOffers = response.data.data;
        _currentPage = response.meta.currentPage;
        _totalPages = response.meta.lastPage;
        _totalCount = response.meta.total;
        _setState(JobOfferState.success);
      },
    );
  }

  // Get featured job offers
  Future<void> getFeaturedJobOffers([int? page, int? perPage]) async {
    _setState(JobOfferState.loading);

    final result = await _repository.getFeaturedJobOffers(page, perPage);

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (response) {
        _featuredJobOffers = response.data.data;
        _setState(JobOfferState.success);
      },
    );
  }

  // Get recent job offers
  Future<void> getRecentJobOffers([int? page, int? perPage]) async {
    _setState(JobOfferState.loading);

    final result = await _repository.getRecentJobOffers(page, perPage);

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (response) {
        _recentJobOffers = response.data.data;
        _setState(JobOfferState.success);
      },
    );
  }

  // Get job offers by category
  Future<void> getJobOffersByCategory(String categoryId, [int? page, int? perPage]) async {
    _setState(JobOfferState.loading);

    final result = await _repository.getJobOffersByCategory(categoryId, page, perPage);

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (response) {
        _lastResponse = response;
        _jobOffers = response.data.data;
        _currentPage = response.meta.currentPage;
        _totalPages = response.meta.lastPage;
        _totalCount = response.meta.total;
        _setState(JobOfferState.success);
      },
    );
  }

  // Get job offers by location
  Future<void> getJobOffersByLocation({
    required double latitude,
    required double longitude,
    double radius = 20.0,
    int? page,
    int? perPage,
  }) async {
    _setState(JobOfferState.loading);

    final result = await _repository.getJobOffersByLocation(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      page: page,
      perPage: perPage,
    );

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (response) {
        _lastResponse = response;
        _jobOffers = response.data.data;
        _currentPage = response.meta.currentPage;
        _totalPages = response.meta.lastPage;
        _totalCount = response.meta.total;
        _setState(JobOfferState.success);
      },
    );
  }

  // Get my job offers
  Future<void> getMyJobOffers([JobOfferQuery? query]) async {
    _setState(JobOfferState.loading);

    final result = await _repository.getMyJobOffers(query);

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (response) {
        _myJobOffers = response.data.data;
        _setState(JobOfferState.success);
      },
    );
  }

  // Get my statistics
  Future<void> getMyStatistics() async {
    _setState(JobOfferState.loading);

    final result = await _repository.getMyStatistics();

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (stats) {
        _myStats = stats;
        _setState(JobOfferState.success);
      },
    );
  }

  // Get public statistics
  Future<void> getPublicStatistics() async {
    _setState(JobOfferState.loading);

    final result = await _repository.getPublicStatistics();

    result.fold(
      (failure) {
        _setError(_getErrorMessage(failure));
      },
      (stats) {
        _publicStats = stats;
        _setState(JobOfferState.success);
      },
    );
  }

  // Filter job offers by status
  List<JobOffer> filterJobOffers({String? status}) {
    if (status == null) return _jobOffers;
    return _jobOffers.where((job) => job.status == status).toList();
  }

  // Filter job offers by urgency
  List<JobOffer> filterJobOffersByUrgency({String? urgency}) {
    if (urgency == null) return _jobOffers;
    return _jobOffers.where((job) => job.urgency == urgency).toList();
  }

  // Sort job offers
  List<JobOffer> sortJobOffers({
    String sortBy = 'created_at',
    bool ascending = false,
  }) {
    final jobs = List<JobOffer>.from(_jobOffers);
    
    jobs.sort((a, b) {
      int comparison;
      switch (sortBy) {
        case 'title':
          comparison = a.title.compareTo(b.title);
          break;
        case 'price':
          comparison = a.estimatedPrice.compareTo(b.estimatedPrice);
          break;
        case 'deadline':
          comparison = a.deadline.compareTo(b.deadline);
          break;
        case 'urgency':
          final urgencyOrder = {'low': 1, 'normal': 2, 'high': 3};
          comparison = (urgencyOrder[a.urgency] ?? 2).compareTo(urgencyOrder[b.urgency] ?? 2);
          break;
        case 'created_at':
        default:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
      }
      return ascending ? comparison : -comparison;
    });
    
    return jobs;
  }

  // Get job offer by ID
  JobOffer? getJobOfferById(String id) {
    try {
      return _jobOffers.firstWhere((job) => job.id == id);
    } catch (e) {
      return null;
    }
  }

  // Pagination methods
  Future<void> loadNextPage() async {
    if (hasNextPage && _lastResponse != null) {
      final query = JobOfferQuery(page: _currentPage + 1);
      await getJobOffers(query);
    }
  }

  Future<void> loadPreviousPage() async {
    if (hasPreviousPage && _lastResponse != null) {
      final query = JobOfferQuery(page: _currentPage - 1);
      await getJobOffers(query);
    }
  }

  Future<void> loadPage(int page) async {
    if (page >= 1 && page <= _totalPages) {
      final query = JobOfferQuery(page: page);
      await getJobOffers(query);
    }
  }

  // Clear all data
  void clearData() {
    _jobOffers.clear();
    _featuredJobOffers.clear();
    _recentJobOffers.clear();
    _myJobOffers.clear();
    _selectedJobOffer = null;
    _lastResponse = null;
    _myStats = null;
    _publicStats = null;
    _currentPage = 1;
    _totalPages = 1;
    _totalCount = 0;
    _setState(JobOfferState.initial);
  }

  // Clear error
  void clearError() {
    _errorMessage = '';
    if (_state == JobOfferState.error) {
      _setState(JobOfferState.initial);
    }
  }

  // Private helper methods
  void _setState(JobOfferState newState) {
    _state = newState;
    if (newState != JobOfferState.error) {
      _errorMessage = '';
    }
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setState(JobOfferState.error);
  }

  void _updateJobOfferInLists(JobOffer updatedJobOffer) {
    // Update in main list
    final index = _jobOffers.indexWhere((job) => job.id == updatedJobOffer.id);
    if (index != -1) {
      _jobOffers[index] = updatedJobOffer;
    }

    // Update in my jobs list
    final myIndex = _myJobOffers.indexWhere((job) => job.id == updatedJobOffer.id);
    if (myIndex != -1) {
      _myJobOffers[myIndex] = updatedJobOffer;
    }

    // Update in featured list
    final featuredIndex = _featuredJobOffers.indexWhere((job) => job.id == updatedJobOffer.id);
    if (featuredIndex != -1) {
      _featuredJobOffers[featuredIndex] = updatedJobOffer;
    }

    // Update in recent list
    final recentIndex = _recentJobOffers.indexWhere((job) => job.id == updatedJobOffer.id);
    if (recentIndex != -1) {
      _recentJobOffers[recentIndex] = updatedJobOffer;
    }
  }

  String _getErrorMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.userFriendlyMessage ?? failure.message;
    } else if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network and try again.';
    } else if (failure is ValidationFailure) {
      return failure.userFriendlyMessage ?? failure.message;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Utility getters
  bool get hasData => _jobOffers.isNotEmpty;
  bool get hasFeaturedJobs => _featuredJobOffers.isNotEmpty;
  bool get hasRecentJobs => _recentJobOffers.isNotEmpty;
  bool get hasMyJobs => _myJobOffers.isNotEmpty;
  bool get isLoading => _state == JobOfferState.loading;
  bool get hasError => _state == JobOfferState.error;
  bool get isSuccess => _state == JobOfferState.success;

  // Check if any operation is in progress
  bool get isOperationInProgress => 
      isLoading || _isCreating || _isUpdating || _isDeleting || 
      _isPublishing || _isCancelling || _isStarting || _isCompleting;

  // Quick filters for my jobs
  List<JobOffer> get myDraftJobs => _myJobOffers.where((job) => job.isDraft).toList();
  List<JobOffer> get myPublishedJobs => _myJobOffers.where((job) => job.isPublished).toList();
  List<JobOffer> get myInProgressJobs => _myJobOffers.where((job) => job.isInProgress).toList();
  List<JobOffer> get myCompletedJobs => _myJobOffers.where((job) => job.isCompleted).toList();
  List<JobOffer> get myCancelledJobs => _myJobOffers.where((job) => job.isCancelled).toList();

  // Quick filters for urgency
  List<JobOffer> get urgentJobs => _jobOffers.where((job) => job.isUrgent).toList();
  List<JobOffer> get normalJobs => _jobOffers.where((job) => job.isNormalUrgency).toList();
  List<JobOffer> get lowUrgencyJobs => _jobOffers.where((job) => job.isLowUrgency).toList();

  // Statistics getters
  int get myDraftCount => myDraftJobs.length;
  int get myPublishedCount => myPublishedJobs.length;
  int get myInProgressCount => myInProgressJobs.length;
  int get myCompletedCount => myCompletedJobs.length;
  int get myCancelledCount => myCancelledJobs.length;
}