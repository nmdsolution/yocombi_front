// Supporting model classes for API responses

import '../../domain/entities/job_offer.dart';
import '../../domain/entities/job_offer_request.dart';
import 'job_offer_model.dart';

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

  const JobOfferStatsModel({
    required this.count,
    this.draftCount = 0,
    this.publishedCount = 0,
    this.inProgressCount = 0,
    this.completedCount = 0,
    this.cancelledCount = 0,
    this.featuredCount = 0,
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
    return JobOfferMetaModel(
      total: json['total'] as int? ?? 0,
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 10,
      stats: JobOfferStatsModel.fromJson(json['stats'] ?? {}),
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

class JobOfferResponseModel {
  final String message;
  final JobOfferModel data;
  final String status;

  const JobOfferResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory JobOfferResponseModel.fromJson(Map<String, dynamic> json) {
    return JobOfferResponseModel(
      message: json['message'] as String? ?? '',
      data: JobOfferModel.fromJson(json['data'] ?? {}),
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

  JobOfferResponse toEntity() {
    return JobOfferResponse(
      message: message,
      data: data.toEntity(),
      status: status,
    );
  }
}

// Statistics models

class UserStatsModel {
  final int totalJobOffers;
  final int draftJobOffers;
  final int publishedJobOffers;
  final int inProgressJobOffers;
  final int completedJobOffers;
  final int cancelledJobOffers;
  final double totalSpent;
  final double averagePrice;
  final int totalApplications;

  const UserStatsModel({
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

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
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

  UserStats toEntity() {
    return UserStats(
      totalJobOffers: totalJobOffers,
      draftJobOffers: draftJobOffers,
      publishedJobOffers: publishedJobOffers,
      inProgressJobOffers: inProgressJobOffers,
      completedJobOffers: completedJobOffers,
      cancelledJobOffers: cancelledJobOffers,
      totalSpent: totalSpent,
      averagePrice: averagePrice,
      totalApplications: totalApplications,
    );
  }
}

class PublicStatsModel {
  final int totalJobOffers;
  final int activeJobOffers;
  final int completedJobOffers;
  final int totalUsers;
  final double averagePrice;
  final Map<String, int> categoriesStats;

  const PublicStatsModel({
    required this.totalJobOffers,
    required this.activeJobOffers,
    required this.completedJobOffers,
    required this.totalUsers,
    required this.averagePrice,
    required this.categoriesStats,
  });

  factory PublicStatsModel.fromJson(Map<String, dynamic> json) {
    return PublicStatsModel(
      totalJobOffers: json['total_job_offers'] as int? ?? 0,
      activeJobOffers: json['active_job_offers'] as int? ?? 0,
      completedJobOffers: json['completed_job_offers'] as int? ?? 0,
      totalUsers: json['total_users'] as int? ?? 0,
      averagePrice: (json['average_price'] as num?)?.toDouble() ?? 0.0,
      categoriesStats: Map<String, int>.from(json['categories_stats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_job_offers': totalJobOffers,
      'active_job_offers': activeJobOffers,
      'completed_job_offers': completedJobOffers,
      'total_users': totalUsers,
      'average_price': averagePrice,
      'categories_stats': categoriesStats,
    };
  }

  PublicStats toEntity() {
    return PublicStats(
      totalJobOffers: totalJobOffers,
      activeJobOffers: activeJobOffers,
      completedJobOffers: completedJobOffers,
      totalUsers: totalUsers,
      averagePrice: averagePrice,
      categoriesStats: categoriesStats,
    );
  }
}

class UserStatsResponseModel {
  final String message;
  final UserStatsModel data;
  final String status;

  const UserStatsResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory UserStatsResponseModel.fromJson(Map<String, dynamic> json) {
    return UserStatsResponseModel(
      message: json['message'] as String? ?? '',
      data: UserStatsModel.fromJson(json['data'] ?? {}),
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

  UserStatsResponse toEntity() {
    return UserStatsResponse(
      message: message,
      data: data.toEntity(),
      status: status,
    );
  }
}

class PublicStatsResponseModel {
  final String message;
  final PublicStatsModel data;
  final String status;

  const PublicStatsResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory PublicStatsResponseModel.fromJson(Map<String, dynamic> json) {
    return PublicStatsResponseModel(
      message: json['message'] as String? ?? '',
      data: PublicStatsModel.fromJson(json['data'] ?? {}),
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

  PublicStatsResponse toEntity() {
    return PublicStatsResponse(
      message: message,
      data: data.toEntity(),
      status: status,
    );
  }
}