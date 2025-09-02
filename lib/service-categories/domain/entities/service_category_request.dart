// lib/domain/entities/service_category_request.dart
class ServiceCategoryRequest {
  final String? name;
  final String? description;
  final String? icon;
  final bool? isActive;
  final int? sortOrder;

  const ServiceCategoryRequest({
    this.name,
    this.description,
    this.icon,
    this.isActive,
    this.sortOrder,
  });

  // Factory constructor for creating a service category
  factory ServiceCategoryRequest.create({
    required String name,
    required String description,
    required String icon,
    bool isActive = true,
    int sortOrder = 1,
  }) {
    return ServiceCategoryRequest(
      name: name,
      description: description,
      icon: icon,
      isActive: isActive,
      sortOrder: sortOrder,
    );
  }

  // Factory constructor for updating a service category
  factory ServiceCategoryRequest.update({
    String? name,
    String? description,
    String? icon,
    bool? isActive,
    int? sortOrder,
  }) {
    return ServiceCategoryRequest(
      name: name,
      description: description,
      icon: icon,
      isActive: isActive,
      sortOrder: sortOrder,
    );
  }

  // Copy with method for modifications
  ServiceCategoryRequest copyWith({
    String? name,
    String? description,
    String? icon,
    bool? isActive,
    int? sortOrder,
  }) {
    return ServiceCategoryRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  // Validation methods
  bool get isValidForCreate => 
      name != null && name!.isNotEmpty && 
      description != null && description!.isNotEmpty &&
      icon != null && icon!.isNotEmpty;

  bool get isValidForUpdate => 
      name != null || description != null || icon != null || 
      isActive != null || sortOrder != null;

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (icon != null) data['icon'] = icon;
    if (isActive != null) data['is_active'] = isActive;
    if (sortOrder != null) data['sort_order'] = sortOrder;
    
    return data;
  }

  @override
  String toString() {
    return 'ServiceCategoryRequest(name: $name, description: $description, icon: $icon, isActive: $isActive, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ServiceCategoryRequest &&
        other.name == name &&
        other.description == description &&
        other.icon == icon &&
        other.isActive == isActive &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        icon.hashCode ^
        isActive.hashCode ^
        sortOrder.hashCode;
  }
}

// Query parameters for filtering and pagination
class ServiceCategoryQuery {
  final bool? activeOnly;
  final bool? ordered;
  final int? page;
  final int? perPage;
  final String? search;
  final String? sortBy;
  final String? sortOrder;

  const ServiceCategoryQuery({
    this.activeOnly,
    this.ordered,
    this.page,
    this.perPage,
    this.search,
    this.sortBy,
    this.sortOrder,
  });

  // Factory constructor for active categories only
  factory ServiceCategoryQuery.activeOnly({
    bool ordered = true,
  }) {
    return ServiceCategoryQuery(
      activeOnly: true,
      ordered: ordered,
    );
  }

  // Factory constructor for paginated results
  factory ServiceCategoryQuery.paginated({
    int page = 1,
    int perPage = 10,
    bool? activeOnly,
    bool ordered = true,
    String? search,
  }) {
    return ServiceCategoryQuery(
      page: page,
      perPage: perPage,
      activeOnly: activeOnly,
      ordered: ordered,
      search: search,
    );
  }

  // Convert to query parameters map
  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {};
    
    if (activeOnly != null) params['active_only'] = activeOnly.toString();
    if (ordered != null) params['ordered'] = ordered.toString();
    if (page != null) params['page'] = page.toString();
    if (perPage != null) params['per_page'] = perPage.toString();
    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    
    return params;
  }

  @override
  String toString() {
    return 'ServiceCategoryQuery(activeOnly: $activeOnly, ordered: $ordered, page: $page, perPage: $perPage, search: $search)';
  }
}