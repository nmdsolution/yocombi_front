// lib/domain/entities/job_offer_request.dart
class JobOfferRequest {
  final String? categoryId;
  final String? title;
  final String? description;
  final double? estimatedPrice;
  final String? currency;
  final double? latitude;
  final double? longitude;
  final String? location;
  final List<String>? photos;
  final DateTime? deadline;
  final String? urgency;
  final String? status;

  const JobOfferRequest({
    this.categoryId,
    this.title,
    this.description,
    this.estimatedPrice,
    this.currency,
    this.latitude,
    this.longitude,
    this.location,
    this.photos,
    this.deadline,
    this.urgency,
    this.status,
  });

  // Factory constructor for creating a job offer
  factory JobOfferRequest.create({
    required String categoryId,
    required String title,
    required String description,
    required double estimatedPrice,
    String currency = 'XAF',
    required double latitude,
    required double longitude,
    required String location,
    List<String> photos = const [],
    required DateTime deadline,
    String urgency = 'normal',
    String status = 'draft',
  }) {
    return JobOfferRequest(
      categoryId: categoryId,
      title: title,
      description: description,
      estimatedPrice: estimatedPrice,
      currency: currency,
      latitude: latitude,
      longitude: longitude,
      location: location,
      photos: photos,
      deadline: deadline,
      urgency: urgency,
      status: status,
    );
  }

  // Factory constructor for updating a job offer
  factory JobOfferRequest.update({
    String? categoryId,
    String? title,
    String? description,
    double? estimatedPrice,
    String? currency,
    double? latitude,
    double? longitude,
    String? location,
    List<String>? photos,
    DateTime? deadline,
    String? urgency,
    String? status,
  }) {
    return JobOfferRequest(
      categoryId: categoryId,
      title: title,
      description: description,
      estimatedPrice: estimatedPrice,
      currency: currency,
      latitude: latitude,
      longitude: longitude,
      location: location,
      photos: photos,
      deadline: deadline,
      urgency: urgency,
      status: status,
    );
  }

  // Copy with method for modifications
  JobOfferRequest copyWith({
    String? categoryId,
    String? title,
    String? description,
    double? estimatedPrice,
    String? currency,
    double? latitude,
    double? longitude,
    String? location,
    List<String>? photos,
    DateTime? deadline,
    String? urgency,
    String? status,
  }) {
    return JobOfferRequest(
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      currency: currency ?? this.currency,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      location: location ?? this.location,
      photos: photos ?? this.photos,
      deadline: deadline ?? this.deadline,
      urgency: urgency ?? this.urgency,
      status: status ?? this.status,
    );
  }

  // Validation methods
  bool get isValidForCreate => 
      categoryId != null && categoryId!.isNotEmpty && 
      title != null && title!.isNotEmpty &&
      description != null && description!.isNotEmpty &&
      estimatedPrice != null && estimatedPrice! > 0 &&
      latitude != null && longitude != null &&
      location != null && location!.isNotEmpty &&
      deadline != null && deadline!.isAfter(DateTime.now());

  bool get isValidForUpdate => 
      categoryId != null || title != null || description != null || 
      estimatedPrice != null || currency != null || latitude != null ||
      longitude != null || location != null || photos != null ||
      deadline != null || urgency != null || status != null;

  bool get isValidForPartialUpdate => isValidForUpdate;

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (categoryId != null) data['category_id'] = categoryId;
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (estimatedPrice != null) data['estimated_price'] = estimatedPrice;
    if (currency != null) data['currency'] = currency;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (location != null) data['location'] = location;
    if (photos != null) data['photos'] = photos;
    if (deadline != null) data['deadline'] = deadline!.toIso8601String();
    if (urgency != null) data['urgency'] = urgency;
    if (status != null) data['status'] = status;
    
    return data;
  }

  @override
  String toString() {
    return 'JobOfferRequest(categoryId: $categoryId, title: $title, estimatedPrice: $estimatedPrice, urgency: $urgency, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is JobOfferRequest &&
        other.categoryId == categoryId &&
        other.title == title &&
        other.description == description &&
        other.estimatedPrice == estimatedPrice &&
        other.urgency == urgency &&
        other.status == status;
  }

  @override
  int get hashCode {
    return categoryId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        estimatedPrice.hashCode ^
        urgency.hashCode ^
        status.hashCode;
  }

  // Helper getters
  bool get isDraft => status == 'draft';
  bool get isPublished => status == 'published';
  bool get hasPhotos => photos != null && photos!.isNotEmpty;
  bool get isUrgent => urgency == 'high';
  
  String? get formattedPrice {
    if (estimatedPrice == null || currency == null) return null;
    return '${estimatedPrice!.toStringAsFixed(0)} $currency';
  }
}

// Query parameters for filtering and pagination
class JobOfferQuery {
  final String? categoryId;
  final String? status;
  final String? urgency;
  final double? priceMin;
  final double? priceMax;
  final String? location;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final String? query; // Search query
  final bool? featuredOnly;
  final bool? recentOnly;
  final int? page;
  final int? perPage;
  final String? sortBy;
  final String? sortOrder;

  const JobOfferQuery({
    this.categoryId,
    this.status,
    this.urgency,
    this.priceMin,
    this.priceMax,
    this.location,
    this.latitude,
    this.longitude,
    this.radius,
    this.query,
    this.featuredOnly,
    this.recentOnly,
    this.page,
    this.perPage,
    this.sortBy,
    this.sortOrder,
  });

  // Factory constructor for featured job offers only
  factory JobOfferQuery.featuredOnly({
    int? page,
    int? perPage,
  }) {
    return JobOfferQuery(
      featuredOnly: true,
      page: page,
      perPage: perPage,
    );
  }

  // Factory constructor for recent job offers
  factory JobOfferQuery.recent({
    int? page,
    int? perPage,
  }) {
    return JobOfferQuery(
      recentOnly: true,
      page: page,
      perPage: perPage,
      sortBy: 'created_at',
      sortOrder: 'desc',
    );
  }

  // Factory constructor for job offers by category
  factory JobOfferQuery.byCategory(
    String categoryId, {
    String? status,
    int? page,
    int? perPage,
  }) {
    return JobOfferQuery(
      categoryId: categoryId,
      status: status,
      page: page,
      perPage: perPage,
    );
  }

  // Factory constructor for job offers by location
  factory JobOfferQuery.byLocation({
    required double latitude,
    required double longitude,
    double radius = 20.0,
    int? page,
    int? perPage,
  }) {
    return JobOfferQuery(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      page: page,
      perPage: perPage,
    );
  }

  // Factory constructor for search
  factory JobOfferQuery.search({
    required String query,
    String? categoryId,
    String? location,
    double? priceMin,
    double? priceMax,
    String? urgency,
    int? page,
    int? perPage,
  }) {
    return JobOfferQuery(
      query: query,
      categoryId: categoryId,
      location: location,
      priceMin: priceMin,
      priceMax: priceMax,
      urgency: urgency,
      page: page,
      perPage: perPage,
    );
  }

  // Factory constructor for paginated results
  factory JobOfferQuery.paginated({
    int page = 1,
    int perPage = 10,
    String? status,
    String? categoryId,
    String? urgency,
    bool? featuredOnly,
    String? sortBy,
    String? sortOrder,
  }) {
    return JobOfferQuery(
      page: page,
      perPage: perPage,
      status: status,
      categoryId: categoryId,
      urgency: urgency,
      featuredOnly: featuredOnly,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  // Convert to query parameters map
  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {};
    
    if (categoryId != null) params['category_id'] = categoryId;
    if (status != null) params['status'] = status;
    if (urgency != null) params['urgency'] = urgency;
    if (priceMin != null) params['price_min'] = priceMin.toString();
    if (priceMax != null) params['price_max'] = priceMax.toString();
    if (location != null) params['location'] = location;
    if (latitude != null) params['latitude'] = latitude.toString();
    if (longitude != null) params['longitude'] = longitude.toString();
    if (radius != null) params['radius'] = radius.toString();
    if (query != null && query!.isNotEmpty) params['query'] = query;
    if (featuredOnly != null) params['featured_only'] = featuredOnly.toString();
    if (recentOnly != null) params['recent_only'] = recentOnly.toString();
    if (page != null) params['page'] = page.toString();
    if (perPage != null) params['per_page'] = perPage.toString();
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    
    return params;
  }

  @override
  String toString() {
    return 'JobOfferQuery(categoryId: $categoryId, status: $status, urgency: $urgency, page: $page, perPage: $perPage, query: $query)';
  }

  JobOfferQuery copyWith({
    String? categoryId,
    String? status,
    String? urgency,
    double? priceMin,
    double? priceMax,
    String? location,
    double? latitude,
    double? longitude,
    double? radius,
    String? query,
    bool? featuredOnly,
    bool? recentOnly,
    int? page,
    int? perPage,
    String? sortBy,
    String? sortOrder,
  }) {
    return JobOfferQuery(
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      urgency: urgency ?? this.urgency,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      query: query ?? this.query,
      featuredOnly: featuredOnly ?? this.featuredOnly,
      recentOnly: recentOnly ?? this.recentOnly,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  // Helper getters
  bool get hasLocationFilter => latitude != null && longitude != null;
  bool get hasPriceFilter => priceMin != null || priceMax != null;
  bool get hasSearchQuery => query != null && query!.isNotEmpty;
  bool get isFilterEmpty => 
      categoryId == null && status == null && urgency == null &&
      priceMin == null && priceMax == null && location == null &&
      !hasLocationFilter && !hasSearchQuery && featuredOnly != true;
}

// User statistics response
class UserStatsResponse {
  final String message;
  final UserStats data;
  final String status;

  const UserStatsResponse({
    required this.message,
    required this.data,
    required this.status,
  });

  factory UserStatsResponse.fromJson(Map<String, dynamic> json) {
    return UserStatsResponse(
      message: json['message'] as String? ?? '',
      data: UserStats.fromJson(json['data'] ?? {}),
      status: json['status'] as String? ?? 'success',
    );
  }
}

class UserStats {
  final int totalJobOffers;
  final int draftJobOffers;
  final int publishedJobOffers;
  final int inProgressJobOffers;
  final int completedJobOffers;
  final int cancelledJobOffers;
  final double totalSpent;
  final double averagePrice;
  final int totalApplications;

  const UserStats({
    required this.totalJobOffers,
    required this.draftJobOffers,
    required this.publishedJobOffers,
    required this.inProgressJobOffers,
    required this.completedJobOffers,
    required this.cancelledJobOffers,
    required this.totalSpent,
    required this.averagePrice,
    required this.totalApplications,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalJobOffers: json['total_job_offers'] as int? ?? 0,
      draftJobOffers: json['draft_job_offers'] as int? ?? 0,
      publishedJobOffers: json['published_job_offers'] as int? ?? 0,
      inProgressJobOffers: json['in_progress_job_offers'] as int? ?? 0,
      completedJobOffers: json['completed_job_offers'] as int? ?? 0,
      cancelledJobOffers: json['cancelled_job_offers'] as int? ?? 0,
      totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0.0,
      averagePrice: (json['average_price'] as num?)?.toDouble() ?? 0.0,
      totalApplications: json['total_applications'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_job_offers': totalJobOffers,
      'draft_job_offers': draftJobOffers,
      'published_job_offers': publishedJobOffers,
      'in_progress_job_offers': inProgressJobOffers,
      'completed_job_offers': completedJobOffers,
      'cancelled_job_offers': cancelledJobOffers,
      'total_spent': totalSpent,
      'average_price': averagePrice,
      'total_applications': totalApplications,
    };
  }
}