// lib/job-offer/domain/entities/job_offer.dart (Fixed)
class JobOffer {
  final String id;
  final String categoryId;
  final String title;
  final String description;
  final double estimatedPrice;
  final String currency;
  final double latitude;
  final double longitude;
  final String location;
  final List<String> photos;
  final DateTime deadline;
  final String urgency; // low, normal, high
  final String status; // draft, published, in_progress, completed, cancelled
  final String? statusLabel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String formattedCreatedAt;
  final String formattedUpdatedAt;
  final String? clientId;
  final String? clientName;
  final String? categoryName;
  final bool isFeatured;
  final int viewsCount;
  final int applicationsCount;

  const JobOffer({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.estimatedPrice,
    required this.currency,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.photos,
    required this.deadline,
    required this.urgency,
    required this.status,
    this.statusLabel,
    required this.createdAt,
    required this.updatedAt,
    required this.formattedCreatedAt,
    required this.formattedUpdatedAt,
    this.clientId,
    this.clientName,
    this.categoryName,
    this.isFeatured = false,
    this.viewsCount = 0,
    this.applicationsCount = 0,
  });

  factory JobOffer.fromJson(Map<String, dynamic> json) {
    // Handle nested estimated_price structure
    double estimatedPrice = 0.0;
    String currency = 'XAF';
    
    final priceData = json['estimated_price'];
    if (priceData is Map<String, dynamic>) {
      // New API structure with nested price object
      estimatedPrice = (priceData['amount'] as num?)?.toDouble() ?? 0.0;
      currency = priceData['currency'] as String? ?? 'XAF';
    } else if (priceData is num) {
      // Legacy structure with direct number
      estimatedPrice = priceData.toDouble();
      currency = json['currency'] as String? ?? 'XAF';
    }
    
    // Handle nested location structure
    double latitude = 0.0;
    double longitude = 0.0;
    String location = '';
    
    final locationData = json['location'];
    if (locationData is Map<String, dynamic>) {
      // New API structure with nested location object
      latitude = (locationData['latitude'] as num?)?.toDouble() ?? 0.0;
      longitude = (locationData['longitude'] as num?)?.toDouble() ?? 0.0;
      location = locationData['address'] as String? ?? '';
    } else {
      // Legacy structure with separate fields
      latitude = (json['latitude'] as num?)?.toDouble() ?? 0.0;
      longitude = (json['longitude'] as num?)?.toDouble() ?? 0.0;
      location = json['location'] as String? ?? '';
    }

    return JobOffer(
      id: json['id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      estimatedPrice: estimatedPrice,
      currency: currency,
      latitude: latitude,
      longitude: longitude,
      location: location,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      deadline: _parseDateTime(json['deadline']),
      urgency: json['urgency'] as String? ?? 'normal',
      status: json['status'] as String? ?? 'draft',
      statusLabel: json['status_label'] as String?,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      formattedCreatedAt: json['formatted_created_at'] as String? ?? '',
      formattedUpdatedAt: json['formatted_updated_at'] as String? ?? '',
      clientId: json['client_id']?.toString() ?? json['user_id']?.toString(),
      clientName: json['client_name'] as String?,
      categoryName: json['category_name'] as String?,
      isFeatured: json['is_featured'] as bool? ?? false,
      viewsCount: json['views_count'] as int? ?? 0,
      applicationsCount: json['applications_count'] as int? ?? 0,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'estimated_price': {
        'amount': estimatedPrice,
        'currency': currency,
        'formatted': '${estimatedPrice.toStringAsFixed(0)} $currency',
      },
      'location': {
        'latitude': latitude,
        'longitude': longitude,
        'address': location,
        'has_coordinates': latitude != 0.0 || longitude != 0.0,
      },
      'photos': photos,
      'deadline': deadline.toIso8601String(),
      'urgency': urgency,
      'status': status,
      'status_label': statusLabel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'formatted_created_at': formattedCreatedAt,
      'formatted_updated_at': formattedUpdatedAt,
      'client_id': clientId,
      'client_name': clientName,
      'category_name': categoryName,
      'is_featured': isFeatured,
      'views_count': viewsCount,
      'applications_count': applicationsCount,
    };
  }

  JobOffer copyWith({
    String? id,
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
    String? statusLabel,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? formattedCreatedAt,
    String? formattedUpdatedAt,
    String? clientId,
    String? clientName,
    String? categoryName,
    bool? isFeatured,
    int? viewsCount,
    int? applicationsCount,
  }) {
    return JobOffer(
      id: id ?? this.id,
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
      statusLabel: statusLabel ?? this.statusLabel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      formattedCreatedAt: formattedCreatedAt ?? this.formattedCreatedAt,
      formattedUpdatedAt: formattedUpdatedAt ?? this.formattedUpdatedAt,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      categoryName: categoryName ?? this.categoryName,
      isFeatured: isFeatured ?? this.isFeatured,
      viewsCount: viewsCount ?? this.viewsCount,
      applicationsCount: applicationsCount ?? this.applicationsCount,
    );
  }

  @override
  String toString() {
    return 'JobOffer(id: $id, title: $title, status: $status, estimatedPrice: $estimatedPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is JobOffer &&
        other.id == id &&
        other.title == title &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        status.hashCode;
  }

  // Helper getters
  bool get isDraft => status == 'draft';
  bool get isPublished => status == 'published';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  
  bool get isUrgent => urgency == 'high';
  bool get isNormalUrgency => urgency == 'normal';
  bool get isLowUrgency => urgency == 'low';
  
  bool get hasPhotos => photos.isNotEmpty;
  bool get hasDeadlinePassed => deadline.isBefore(DateTime.now());
  
  String get formattedPrice => '${estimatedPrice.toStringAsFixed(0)} $currency';
}

// Supporting classes for API responses - Updated to handle nested structures
class JobOfferListResponse {
  final String message;
  final JobOfferData data;
  final JobOfferMeta meta;
  final String status;

  const JobOfferListResponse({
    required this.message,
    required this.data,
    required this.meta,
    required this.status,
  });

  factory JobOfferListResponse.fromJson(Map<String, dynamic> json) {
    return JobOfferListResponse(
      message: json['message'] as String? ?? '',
      data: JobOfferData.fromJson(json['data'] ?? {}),
      meta: JobOfferMeta.fromJson(json['meta'] ?? {}),
      status: json['status'] as String? ?? 'success',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
      'meta': meta.toJson(),
      'status': status,
    };
  }
}

class JobOfferData {
  final List<JobOffer> data;
  final JobOfferStats? meta;

  const JobOfferData({
    required this.data,
    this.meta,
  });

  factory JobOfferData.fromJson(Map<String, dynamic> json) {
    return JobOfferData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => JobOffer.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      meta: json['meta'] != null ? JobOfferStats.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      if (meta != null) 'meta': meta!.toJson(),
    };
  }
}

class JobOfferStats {
  final int count;
  final int draftCount;
  final int publishedCount;
  final int inProgressCount;
  final int completedCount;
  final int cancelledCount;
  final int featuredCount;

  const JobOfferStats({
    required this.count,
    this.draftCount = 0,
    this.publishedCount = 0,
    this.inProgressCount = 0,
    this.completedCount = 0,
    this.cancelledCount = 0,
    this.featuredCount = 0,
  });

  factory JobOfferStats.fromJson(Map<String, dynamic> json) {
    return JobOfferStats(
      count: json['count'] as int? ?? 0,
      draftCount: json['draft_count'] as int? ?? 0,
      publishedCount: json['published_count'] as int? ?? 0,
      inProgressCount: json['in_progress_count'] as int? ?? 0,
      completedCount: json['completed_count'] as int? ?? 0,
      cancelledCount: json['cancelled_count'] as int? ?? 0,
      featuredCount: json['featured_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'draft_count': draftCount,
      'published_count': publishedCount,
      'in_progress_count': inProgressCount,
      'completed_count': completedCount,
      'cancelled_count': cancelledCount,
      'featured_count': featuredCount,
    };
  }
}

class JobOfferMeta {
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final JobOfferStats stats;
  final JobOfferFilters filters;

  const JobOfferMeta({
    required this.total,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    required this.stats,
    required this.filters,
  });

  factory JobOfferMeta.fromJson(Map<String, dynamic> json) {
    // Handle case where stats might be directly in meta or nested in data.meta
    final statsData = json['stats'] ?? json;
    
    return JobOfferMeta(
      total: json['total'] as int? ?? (json['count'] as int? ?? 0),
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 10,
      stats: JobOfferStats.fromJson(statsData),
      filters: JobOfferFilters.fromJson(json['filters'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'stats': stats.toJson(),
      'filters': filters.toJson(),
    };
  }
}

class JobOfferFilters {
  final String? categoryId;
  final String? status;
  final String? urgency;
  final double? priceMin;
  final double? priceMax;
  final String? location;
  final double? radius;
  final bool featuredOnly;

  const JobOfferFilters({
    this.categoryId,
    this.status,
    this.urgency,
    this.priceMin,
    this.priceMax,
    this.location,
    this.radius,
    this.featuredOnly = false,
  });

  factory JobOfferFilters.fromJson(Map<String, dynamic> json) {
    return JobOfferFilters(
      categoryId: json['category_id']?.toString(),
      status: json['status'] as String?,
      urgency: json['urgency'] as String?,
      priceMin: (json['price_min'] as num?)?.toDouble(),
      priceMax: (json['price_max'] as num?)?.toDouble(),
      location: json['location'] as String?,
      radius: (json['radius'] as num?)?.toDouble(),
      featuredOnly: json['featured_only'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (categoryId != null) 'category_id': categoryId,
      if (status != null) 'status': status,
      if (urgency != null) 'urgency': urgency,
      if (priceMin != null) 'price_min': priceMin,
      if (priceMax != null) 'price_max': priceMax,
      if (location != null) 'location': location,
      if (radius != null) 'radius': radius,
      'featured_only': featuredOnly,
    };
  }
}

class JobOfferResponse {
  final String message;
  final JobOffer data;
  final String status;

  const JobOfferResponse({
    required this.message,
    required this.data,
    required this.status,
  });

  factory JobOfferResponse.fromJson(Map<String, dynamic> json) {
    return JobOfferResponse(
      message: json['message'] as String? ?? '',
      data: JobOffer.fromJson(json['data'] ?? {}),
      status: json['status'] as String? ?? 'success',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
      'status': status,
    };
  }
}

// Public statistics response (unchanged)
class PublicStatsResponse {
  final String message;
  final PublicStats data;
  final String status;

  const PublicStatsResponse({
    required this.message,
    required this.data,
    required this.status,
  });

  factory PublicStatsResponse.fromJson(Map<String, dynamic> json) {
    return PublicStatsResponse(
      message: json['message'] as String? ?? '',
      data: PublicStats.fromJson(json['data'] ?? {}),
      status: json['status'] as String? ?? 'success',
    );
  }
}

class PublicStats {
  final int totalJobOffers;
  final int activeJobOffers;
  final int completedJobOffers;
  final int totalUsers;
  final double averagePrice;
  final Map<String, int> categoriesStats;

  const PublicStats({
    required this.totalJobOffers,
    required this.activeJobOffers,
    required this.completedJobOffers,
    required this.totalUsers,
    required this.averagePrice,
    required this.categoriesStats,
  });

  factory PublicStats.fromJson(Map<String, dynamic> json) {
    return PublicStats(
      totalJobOffers: json['total_job_offers'] as int? ?? 0,
      activeJobOffers: json['active_job_offers'] as int? ?? 0,
      completedJobOffers: json['completed_job_offers'] as int? ?? 0,
      totalUsers: json['total_users'] as int? ?? 0,
      averagePrice: (json['average_price'] as num?)?.toDouble() ?? 0.0,
      categoriesStats: Map<String, int>.from(json['categories_stats'] ?? {}),
    );
  }
}