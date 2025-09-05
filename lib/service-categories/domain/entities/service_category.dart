// lib/domain/entities/service_category.dart
class ServiceCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool isActive;
  final int sortOrder;
  final String statusLabel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String formattedCreatedAt;
  final String formattedUpdatedAt;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.isActive,
    required this.sortOrder,
    required this.statusLabel,
    required this.createdAt,
    required this.updatedAt,
    required this.formattedCreatedAt,
    required this.formattedUpdatedAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
      statusLabel: json['status_label'] as String? ?? 'Actif',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      formattedCreatedAt: json['formatted_created_at'] as String? ?? '',
      formattedUpdatedAt: json['formatted_updated_at'] as String? ?? '',
    );
  }

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

  ServiceCategory copyWith({
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
    return ServiceCategory(
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

  @override
  String toString() {
    return 'ServiceCategory(id: $id, name: $name, isActive: $isActive, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ServiceCategory &&
        other.id == id &&
        other.name == name &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        isActive.hashCode;
  }
}

// Supporting classes for API responses

class ServiceCategoryListResponse {
  final String message;
  final ServiceCategoryData data;
  final ServiceCategoryMeta meta;
  final String status;

  const ServiceCategoryListResponse({
    required this.message,
    required this.data,
    required this.meta,
    required this.status,
  });

  factory ServiceCategoryListResponse.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryListResponse(
      message: json['message'] as String? ?? '',
      data: ServiceCategoryData.fromJson(json['data'] ?? {}),
      meta: ServiceCategoryMeta.fromJson(json['meta'] ?? {}),
      status: json['status'] as String? ?? 'success',
    );
  }
}

class ServiceCategoryData {
  final List<ServiceCategory> data;
  final ServiceCategoryStats meta;

  const ServiceCategoryData({
    required this.data,
    required this.meta,
  });

  factory ServiceCategoryData.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ServiceCategory.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      meta: ServiceCategoryStats.fromJson(json['meta'] ?? {}),
    );
  }
}

class ServiceCategoryStats {
  final int count;
  final int activeCount;
  final int inactiveCount;

  const ServiceCategoryStats({
    required this.count,
    required this.activeCount,
    required this.inactiveCount,
  });

  factory ServiceCategoryStats.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryStats(
      count: json['count'] as int? ?? 0,
      activeCount: json['active_count'] as int? ?? 0,
      inactiveCount: json['inactive_count'] as int? ?? 0,
    );
  }
}

class ServiceCategoryMeta {
  final int total;
  final ServiceCategoryStats stats;
  final ServiceCategoryFilters filters;

  const ServiceCategoryMeta({
    required this.total,
    required this.stats,
    required this.filters,
  });

  factory ServiceCategoryMeta.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryMeta(
      total: json['total'] as int? ?? 0,
      stats: ServiceCategoryStats.fromJson(json['stats'] ?? {}),
      filters: ServiceCategoryFilters.fromJson(json['filters'] ?? {}),
    );
  }
}

class ServiceCategoryFilters {
  final bool activeOnly;
  final bool ordered;

  const ServiceCategoryFilters({
    required this.activeOnly,
    required this.ordered,
  });

  factory ServiceCategoryFilters.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryFilters(
      activeOnly: json['active_only'] as bool? ?? false,
      ordered: json['ordered'] as bool? ?? true,
    );
  }
}

class ServiceCategoryResponse {
  final String message;
  final ServiceCategory data;
  final String status;

  const ServiceCategoryResponse({
    required this.message,
    required this.data,
    required this.status,
  });

  factory ServiceCategoryResponse.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryResponse(
      message: json['message'] as String? ?? '',
      data: ServiceCategory.fromJson(json['data'] ?? {}),
      status: json['status'] as String? ?? 'success',
    );
  }
}