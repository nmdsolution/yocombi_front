// lib/core/enums/enums.dart

enum AuthState {
  initial,
  loading,
  otpSent,      // OTP has been sent
  otpVerified,  // OTP has been verified (for register flow)
  success,      // User is authenticated
  error,        // Error occurred
}

enum UserType {
  individual,
  business,
}

enum AccountType {
  both,
  buyer,
  seller,
}

enum OtpMethod {
  email,
  phone,
}

// Enums for Service Categories
enum ServiceCategoryStatus {
  active,
  inactive;

  bool get isActive => this == ServiceCategoryStatus.active;
  bool get isInactive => this == ServiceCategoryStatus.inactive;

  String get label {
    switch (this) {
      case ServiceCategoryStatus.active:
        return ServiceCategoryConstants.activeStatusLabel;
      case ServiceCategoryStatus.inactive:
        return ServiceCategoryConstants.inactiveStatusLabel;
    }
  }
}

enum ServiceCategorySortBy {
  name,
  sortOrder,
  createdAt,
  updatedAt;

  String get value {
    switch (this) {
      case ServiceCategorySortBy.name:
        return 'name';
      case ServiceCategorySortBy.sortOrder:
        return 'sort_order';
      case ServiceCategorySortBy.createdAt:
        return 'created_at';
      case ServiceCategorySortBy.updatedAt:
        return 'updated_at';
    }
  }
}

enum SortOrder {
  ascending,
  descending;

  String get value {
    switch (this) {
      case SortOrder.ascending:
        return 'asc';
      case SortOrder.descending:
        return 'desc';
    }
  }
}

// Extension methods for better usability
extension AuthStateExtension on AuthState {
  String get value {
    switch (this) {
      case AuthState.initial:
        return 'initial';
      case AuthState.loading:
        return 'loading';
      case AuthState.otpSent:
        return 'otp_sent';
      case AuthState.otpVerified:
        return 'otp_verified';
      case AuthState.success:
        return 'success';
      case AuthState.error:
        return 'error';
    }
  }

  bool get isLoading => this == AuthState.loading;
  bool get isSuccess => this == AuthState.success;
  bool get hasError => this == AuthState.error;
}

extension UserTypeExtension on UserType {
  String get value {
    switch (this) {
      case UserType.individual:
        return 'individual';
      case UserType.business:
        return 'business';
    }
  }

  String get displayName {
    switch (this) {
      case UserType.individual:
        return 'Individual';
      case UserType.business:
        return 'Business';
    }
  }
}

extension AccountTypeExtension on AccountType {
  String get value {
    switch (this) {
      case AccountType.both:
        return 'both';
      case AccountType.buyer:
        return 'buyer';
      case AccountType.seller:
        return 'seller';
    }
  }

  String get displayName {
    switch (this) {
      case AccountType.both:
        return 'Both';
      case AccountType.buyer:
        return 'Buyer';
      case AccountType.seller:
        return 'Seller';
    }
  }
}

extension OtpMethodExtension on OtpMethod {
  String get value {
    switch (this) {
      case OtpMethod.email:
        return 'email';
      case OtpMethod.phone:
        return 'phone';
    }
  }

  String get displayName {
    switch (this) {
      case OtpMethod.email:
        return 'Email';
      case OtpMethod.phone:
        return 'Phone';
    }
  }
}

// Constants class for Service Categories
class ServiceCategoryConstants {
  // Status labels
  static const String activeStatusLabel = 'Actif';
  static const String inactiveStatusLabel = 'Inactif';

  // Default values
  static const int defaultSortOrder = 1;
  static const bool defaultActiveStatus = true;
  static const String defaultSortBy = 'sort_order';
  static const String defaultSortDirection = 'asc';

  // Validation
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int minDescriptionLength = 10;
  static const int maxDescriptionLength = 500;
  static const int minSortOrder = 1;
  static const int maxSortOrder = 999;

  // Cache keys
  static const String allCategoriesCacheKey = 'all_service_categories';
  static const String activeCategoriesCacheKey = 'active_service_categories';

  // Error messages
  static const String createErrorMessage = 'Failed to create service category';
  static const String updateErrorMessage = 'Failed to update service category';
  static const String deleteErrorMessage = 'Failed to delete service category';
  static const String fetchErrorMessage = 'Failed to fetch service categories';
  static const String toggleErrorMessage = 'Failed to toggle service category status';

  // Success messages
  static const String createSuccessMessage = 'Service category created successfully';
  static const String updateSuccessMessage = 'Service category updated successfully';
  static const String deleteSuccessMessage = 'Service category deleted successfully';
  static const String toggleSuccessMessage = 'Service category status updated successfully';

  // Private constructor to prevent instantiation
  ServiceCategoryConstants._();
}