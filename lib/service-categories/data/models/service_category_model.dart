// lib/data/models/service_category_model.dart
import '../../domain/entities/service_category.dart';

class ServiceCategoryModel extends ServiceCategory {
  const ServiceCategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.icon,
    required super.isActive,
    required super.sortOrder,
    required super.statusLabel,
    required super.createdAt,
    required super.updatedAt,
    required super.formattedCreatedAt,
    required super.formattedUpdatedAt,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
      statusLabel: json['status_label'] as String? ?? 'Actif',
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      formattedCreatedAt: json['formatted_created_at'] as String? ?? '',
      formattedUpdatedAt: json['formatted_updated_at'] as String? ?? '',
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
      'name': name,
      'description': description,
      'icon': icon,
      'is_active': isActive,
      'sort_order': sortOrder,
      'status_label': statusLabel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'formatted_created_at': formattedCreatedAt,
      'formatted_updated_at': formattedUpdatedAt,
    };
  }

  ServiceCategory toEntity() {
    return ServiceCategory(
      id: id,
      name: name,
      description: description,
      icon: icon,
      isActive: isActive,
      sortOrder: sortOrder,
      statusLabel: statusLabel,
      createdAt: createdAt,
      updatedAt: updatedAt,
      formattedCreatedAt: formattedCreatedAt,
      formattedUpdatedAt: formattedUpdatedAt,
    );
  }

  ServiceCategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    bool? isActive,
    int? sortOrder,
    String? statusLabel,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? formattedCreatedAt,
    String? formattedUpdatedAt,
  }) {
    return ServiceCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      statusLabel: statusLabel ?? this.statusLabel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      formattedCreatedAt: formattedCreatedAt ?? this.formattedCreatedAt,
      formattedUpdatedAt: formattedUpdatedAt ?? this.formattedUpdatedAt,
    );
  }

  // Factory constructor from entity
  factory ServiceCategoryModel.fromEntity(ServiceCategory entity) {
    return ServiceCategoryModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      icon: entity.icon,
      isActive: entity.isActive,
      sortOrder: entity.sortOrder,
      statusLabel: entity.statusLabel,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      formattedCreatedAt: entity.formattedCreatedAt,
      formattedUpdatedAt: entity.formattedUpdatedAt,
    );
  }

  // Helper method to create a model with updated timestamps
  ServiceCategoryModel withUpdatedTimestamp() {
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
    return 'ServiceCategoryModel(id: $id, name: $name, isActive: $isActive, sortOrder: $sortOrder)';
  }
}

// Supporting model classes for API responses

class ServiceCategoryListResponseModel {
  final String message;
  final ServiceCategoryDataModel data;
  final ServiceCategoryMetaModel meta;
  final String status;

  const ServiceCategoryListResponseModel({
    required this.message,
    required this.data,
    required this.meta,
    required this.status,
  });

  factory ServiceCategoryListResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryListResponseModel(
      message: json['message'] as String? ?? '',
      data: ServiceCategoryDataModel.fromJson(json['data'] ?? {}),
      meta: ServiceCategoryMetaModel.fromJson(json['meta'] ?? {}),
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

  ServiceCategoryListResponse toEntity() {
    return ServiceCategoryListResponse(
      message: message,
      data: data.toEntity(),
      meta: meta.toEntity(),
      status: status,
    );
  }
}

class ServiceCategoryDataModel {
  final List<ServiceCategoryModel> data;
  final ServiceCategoryStatsModel meta;

  const ServiceCategoryDataModel({
    required this.data,
    required this.meta,
  });

  factory ServiceCategoryDataModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryDataModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ServiceCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      meta: ServiceCategoryStatsModel.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }

  ServiceCategoryData toEntity() {
    return ServiceCategoryData(
      data: data.map((model) => model.toEntity()).toList(),
      meta: meta.toEntity(),
    );
  }
}

class ServiceCategoryStatsModel {
  final int count;
  final int activeCount;
  final int inactiveCount;

  const ServiceCategoryStatsModel({
    required this.count,
    required this.activeCount,
    required this.inactiveCount,
  });

  factory ServiceCategoryStatsModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryStatsModel(
      count: json['count'] as int? ?? 0,
      activeCount: json['active_count'] as int? ?? 0,
      inactiveCount: json['inactive_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'active_count': activeCount,
      'inactive_count': inactiveCount,
    };
  }

  ServiceCategoryStats toEntity() {
    return ServiceCategoryStats(
      count: count,
      activeCount: activeCount,
      inactiveCount: inactiveCount,
    );
  }
}

class ServiceCategoryMetaModel {
  final int total;
  final ServiceCategoryStatsModel stats;
  final ServiceCategoryFiltersModel filters;

  const ServiceCategoryMetaModel({
    required this.total,
    required this.stats,
    required this.filters,
  });

  factory ServiceCategoryMetaModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryMetaModel(
      total: json['total'] as int? ?? 0,
      stats: ServiceCategoryStatsModel.fromJson(json['stats'] ?? {}),
      filters: ServiceCategoryFiltersModel.fromJson(json['filters'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'stats': stats.toJson(),
      'filters': filters.toJson(),
    };
  }

  ServiceCategoryMeta toEntity() {
    return ServiceCategoryMeta(
      total: total,
      stats: stats.toEntity(),
      filters: filters.toEntity(),
    );
  }
}

class ServiceCategoryFiltersModel {
  final bool activeOnly;
  final bool ordered;

  const ServiceCategoryFiltersModel({
    required this.activeOnly,
    required this.ordered,
  });

  factory ServiceCategoryFiltersModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryFiltersModel(
      activeOnly: json['active_only'] as bool? ?? false,
      ordered: json['ordered'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active_only': activeOnly,
      'ordered': ordered,
    };
  }

  ServiceCategoryFilters toEntity() {
    return ServiceCategoryFilters(
      activeOnly: activeOnly,
      ordered: ordered,
    );
  }
}

class ServiceCategoryResponseModel {
  final String message;
  final ServiceCategoryModel data;
  final String status;

  const ServiceCategoryResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory ServiceCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryResponseModel(
      message: json['message'] as String? ?? '',
      data: ServiceCategoryModel.fromJson(json['data'] ?? {}),
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

  ServiceCategoryResponse toEntity() {
    return ServiceCategoryResponse(
      message: message,
      data: data.toEntity(),
      status: status,
    );
  }
}