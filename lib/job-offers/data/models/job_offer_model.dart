// lib/data/models/job_offer_model.dart (Fixed)
import '../../domain/entities/job_offer.dart';
import '../../domain/entities/job_offer_request.dart';

class JobOfferModel extends JobOffer {
  const JobOfferModel({
    required super.id,
    required super.categoryId,
    required super.title,
    required super.description,
    required super.estimatedPrice,
    required super.currency,
    required super.latitude,
    required super.longitude,
    required super.location,
    required super.photos,
    required super.deadline,
    required super.urgency,
    required super.status,
    super.statusLabel,
    required super.createdAt,
    required super.updatedAt,
    required super.formattedCreatedAt,
    required super.formattedUpdatedAt,
    super.clientId,
    super.clientName,
    super.categoryName,
    super.isFeatured,
    super.viewsCount,
    super.applicationsCount,
  });

  factory JobOfferModel.fromJson(Map<String, dynamic> json) {
    // Handle estimated_price structure
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
    
    // Handle location structure
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

    return JobOfferModel(
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
      urgency: json['urgency'] as String? ?? 'medium',
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'estimated_price': {
        'amount': estimatedPrice,
        'currency': currency,
        'formatted': '${estimatedPrice.toStringAsFixed(2)} $currency',
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

  JobOffer toEntity() {
    return JobOffer(
      id: id,
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
      statusLabel: statusLabel,
      createdAt: createdAt,
      updatedAt: updatedAt,
      formattedCreatedAt: formattedCreatedAt,
      formattedUpdatedAt: formattedUpdatedAt,
      clientId: clientId,
      clientName: clientName,
      categoryName: categoryName,
      isFeatured: isFeatured,
      viewsCount: viewsCount,
      applicationsCount: applicationsCount,
    );
  }

  JobOfferModel copyWith({
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
    return JobOfferModel(
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

  // Factory constructor from entity
  factory JobOfferModel.fromEntity(JobOffer entity) {
    return JobOfferModel(
      id: entity.id,
      categoryId: entity.categoryId,
      title: entity.title,
      description: entity.description,
      estimatedPrice: entity.estimatedPrice,
      currency: entity.currency,
      latitude: entity.latitude,
      longitude: entity.longitude,
      location: entity.location,
      photos: entity.photos,
      deadline: entity.deadline,
      urgency: entity.urgency,
      status: entity.status,
      statusLabel: entity.statusLabel,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      formattedCreatedAt: entity.formattedCreatedAt,
      formattedUpdatedAt: entity.formattedUpdatedAt,
      clientId: entity.clientId,
      clientName: entity.clientName,
      categoryName: entity.categoryName,
      isFeatured: entity.isFeatured,
      viewsCount: entity.viewsCount,
      applicationsCount: entity.applicationsCount,
    );
  }

  // Helper method to create a model with updated timestamps
  JobOfferModel withUpdatedTimestamp() {
    final now = DateTime.now();
    return copyWith(
      updatedAt: now,
      formattedUpdatedAt: _formatDateTime(now),
    );
  }

  // Helper method to format DateTime
  static String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
           '${dateTime.month.toString().padLeft(2, '0')}/'
           '${dateTime.year} '
           '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'JobOfferModel(id: $id, title: $title, status: $status, estimatedPrice: $estimatedPrice)';
  }
}

// Update the response models to handle the new API structure
class JobOfferListResponseModel {
  final String message;
  final JobOfferDataModel data;
  final JobOfferMetaModel meta;
  final String status;

  const JobOfferListResponseModel({
    required this.message,
    required this.data,
    required this.meta,
    required this.status,
  });

  factory JobOfferListResponseModel.fromJson(Map<String, dynamic> json) {
    return JobOfferListResponseModel(
      message: json['message'] as String? ?? '',
      data: JobOfferDataModel.fromJson(json['data'] ?? {}),
      meta: JobOfferMetaModel.fromJson(json['meta'] ?? {}),
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

  JobOfferListResponse toEntity() {
    return JobOfferListResponse(
      message: message,
      data: data.toEntity(),
      meta: meta.toEntity(),
      status: status,
    );
  }
}

class JobOfferDataModel {
  final List<JobOfferModel> data;
  final JobOfferStatsModel? meta;

  const JobOfferDataModel({
    required this.data,
    this.meta,
  });

  factory JobOfferDataModel.fromJson(Map<String, dynamic> json) {
    return JobOfferDataModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => JobOfferModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      meta: json['meta'] != null ? JobOfferStatsModel.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      if (meta != null) 'meta': meta!.toJson(),
    };
  }

  JobOfferData toEntity() {
    return JobOfferData(
      data: data.map((model) => model.toEntity()).toList(),
      meta: meta?.toEntity(),
    );
  }
}

class JobOfferStatsModel {
  final int count;
  final int draftCount;
  final int publishedCount;
  final int inProgressCount;
  final int completedCount;
  final int cancelledCount;
  final int featuredCount;
  final int activeCount;

  const JobOfferStatsModel({
    required this.count,
    this.draftCount = 0,
    this.publishedCount = 0,
    this.inProgressCount = 0,
    this.completedCount = 0,
    this.cancelledCount = 0,
    this.featuredCount = 0,
    this.activeCount = 0,
  });

  factory JobOfferStatsModel.fromJson(Map<String, dynamic> json) {
    return JobOfferStatsModel(
      count: json['count'] as int? ?? 0,
      draftCount: json['draft_count'] as int? ?? 0,
      publishedCount: json['published_count'] as int? ?? 0,
      inProgressCount: json['in_progress_count'] as int? ?? 0,
      completedCount: json['completed_count'] as int? ?? 0,
      cancelledCount: json['cancelled_count'] as int? ?? 0,
      featuredCount: json['featured_count'] as int? ?? 0,
      activeCount: json['active_count'] as int? ?? 0,
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
      'active_count': activeCount,
    };
  }

  JobOfferStats toEntity() {
    return JobOfferStats(
      count: count,
      draftCount: draftCount,
      publishedCount: publishedCount,
      inProgressCount: inProgressCount,
      completedCount: completedCount,
      cancelledCount: cancelledCount,
      featuredCount: featuredCount,
    );
  }
}

class JobOfferMetaModel {
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final JobOfferStatsModel stats;
  final JobOfferFiltersModel filters;

  const JobOfferMetaModel({
    required this.total,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    required this.stats,
    required this.filters,
  });

  factory JobOfferMetaModel.fromJson(Map<String, dynamic> json) {
    // Handle case where stats might be directly in data.meta or separate
    final statsData = json['stats'] ?? json;
    
    return JobOfferMetaModel(
      total: json['total'] as int? ?? (json['count'] as int? ?? 0),
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 10,
      stats: JobOfferStatsModel.fromJson(statsData),
      filters: JobOfferFiltersModel.fromJson(json['filters'] ?? {}),
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

  JobOfferMeta toEntity() {
    return JobOfferMeta(
      total: total,
      currentPage: currentPage,
      lastPage: lastPage,
      perPage: perPage,
      stats: stats.toEntity(),
      filters: filters.toEntity(),
    );
  }
}

class JobOfferFiltersModel {
  final String? categoryId;
  final String? status;
  final String? urgency;
  final double? priceMin;
  final double? priceMax;
  final String? location;
  final double? radius;
  final bool featuredOnly;

  const JobOfferFiltersModel({
    this.categoryId,
    this.status,
    this.urgency,
    this.priceMin,
    this.priceMax,
    this.location,
    this.radius,
    this.featuredOnly = false,
  });

  factory JobOfferFiltersModel.fromJson(Map<String, dynamic> json) {
    return JobOfferFiltersModel(
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

  JobOfferFilters toEntity() {
    return JobOfferFilters(
      categoryId: categoryId,
      status: status,
      urgency: urgency,
      priceMin: priceMin,
      priceMax: priceMax,
      location: location,
      radius: radius,
      featuredOnly: featuredOnly,
    );
  }
}