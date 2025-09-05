// lib/core/constants/app_constants.dart
class AppConstants {
  // Base URL
  static const String baseUrl = 'http://184.174.39.92:8080/v1';
  
  // Auth endpoints
  static const String loginEndpoint = '/auth/login'; // Direct login with password
  static const String sendOtpEndpoint = '/auth/send-otp';  // Same for login or register
  static const String verifyOtpEndpoint = '/auth/verify-otp';  // Same for login or register
  static const String completeRegistrationEndpoint = '/auth/complete-registration';  // Suite from register
  static const String refreshTokenEndpoint = '/auth/refresh-token';
  
  // Other endpoints
  static const String userEndpoint = '/user';
  static const String profileEndpoint = '/user/profile';
  
  // Service Categories endpoints
  static const String serviceCategoriesEndpoint = '/service-categories';
  static const String serviceCategoryByIdEndpoint = '/service-categories/{id}';
  static const String toggleStatusEndpoint = '/service-categories/{id}/toggle-status';
  
  // Job Offers endpoints
  static const String jobOffersEndpoint = '/job-offers';
  static const String jobOfferByIdEndpoint = '/job-offers/{id}';
  static const String jobOffersSearchEndpoint = '/job-offers/search';
  static const String jobOffersFeaturedEndpoint = '/job-offers/featured';
  static const String jobOffersRecentEndpoint = '/job-offers/recent';
  static const String jobOffersByCategoryEndpoint = '/job-offers/category/{categoryId}';
  static const String jobOffersByLocationEndpoint = '/job-offers/location/{lat}/{lng}';
  static const String myJobOffersEndpoint = '/job-offers/user/my-jobs';
  static const String myJobOffersStatsEndpoint = '/job-offers/user/stats';
  static const String publicJobOffersStatsEndpoint = '/job-offers/stats';
  
  // Job Offer Status Actions endpoints
  static const String publishJobOfferEndpoint = '/job-offers/{id}/publish';
  static const String cancelJobOfferEndpoint = '/job-offers/{id}/cancel';
  static const String startJobOfferEndpoint = '/job-offers/{id}/start';
  static const String completeJobOfferEndpoint = '/job-offers/{id}/complete';
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String tokenTypeKey = 'token_type';
  static const String expiresInKey = 'expires_in';

  // Cache keys
  static const String activeCategoriesCacheKey = 'active_service_categories';
  static const String allCategoriesCacheKey = 'all_service_categories';
  static const String jobOffersCacheKey = 'job_offers_cache';
  static const String featuredJobOffersCacheKey = 'featured_job_offers_cache';
  static const String recentJobOffersCacheKey = 'recent_job_offers_cache';
  
  // App info
  static const String appName = 'YoCombi';
  static const String appVersion = '1.0.0';
  
  // Network timeouts
  static const int connectTimeoutMs = 30000;
  static const int receiveTimeoutMs = 30000;
  static const int sendTimeoutMs = 30000;
  
  // OTP
  static const int otpLength = 6;
  static const int otpResendDelaySeconds = 60;
  
  // Cache durations
  static const Duration cacheExpiry = Duration(hours: 1);
  static const Duration shortCacheExpiry = Duration(minutes: 15);
  static const Duration longCacheExpiry = Duration(hours: 24);
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
  static const int minPageSize = 5;
  
  // Validation constraints
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int minDescriptionLength = 10;
  static const int maxDescriptionLength = 1000;
  static const int minPasswordLength = 6;
  static const int minSortOrder = 1;
  static const int maxSortOrder = 999;
  
  // Job Offer specific constraints
  static const int minTitleLength = 5;
  static const int maxTitleLength = 200;
  static const int minJobDescriptionLength = 20;
  static const int maxJobDescriptionLength = 2000;
  static const double minPrice = 100.0;
  static const double maxPrice = 10000000.0;
  static const double maxLocationRadius = 1000.0; // km
  static const int maxPhotosCount = 10;
  
  // Default values for service categories
  static const int defaultSortOrder = 1;
  static const bool defaultActiveStatus = true;
  static const String defaultSortBy = 'sort_order';
  static const String defaultSortOrderDirection = 'asc';
  
  // Default values for job offers
  static const String defaultCurrency = 'XAF';
  static const String defaultUrgency = 'normal';
  static const String defaultStatus = 'draft';
  static const double defaultLocationRadius = 20.0;
  
  // Status labels
  static const String activeStatusLabel = 'Actif';
  static const String inactiveStatusLabel = 'Inactif';
  
  // Job Offer Status Labels
  static const Map<String, String> jobOfferStatusLabels = {
    'draft': 'Brouillon',
    'published': 'Publié',
    'in_progress': 'En cours',
    'completed': 'Terminé',
    'cancelled': 'Annulé',
  };
  
  // Job Offer Urgency Labels
  static const Map<String, String> jobOfferUrgencyLabels = {
    'low': 'Faible',
    'normal': 'Normal',
    'high': 'Urgent',
  };

  // Regular expressions
  static final RegExp phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
  static final RegExp emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
  static final RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{6,}$');
  static final RegExp priceRegex = RegExp(r'^\d+(\.\d{1,2})?$');
  static final RegExp coordinatesRegex = RegExp(r'^-?\d+(\.\d+)?$');

  // Sort options for Service Categories
  static const List<String> sortByOptions = [
    'name',
    'sort_order',
    'created_at',
    'updated_at',
  ];
  
  // Sort options for Job Offers
  static const List<String> jobOfferSortByOptions = [
    'created_at',
    'updated_at',
    'title',
    'estimated_price',
    'deadline',
    'urgency',
  ];
  
  static const List<String> sortOrderOptions = [
    'asc',
    'desc',
  ];
  
  // Job Offer Status Options
  static const List<String> jobOfferStatusOptions = [
    'draft',
    'published',
    'in_progress',
    'completed',
    'cancelled',
  ];
  
  // Job Offer Urgency Options
  static const List<String> jobOfferUrgencyOptions = [
    'low',
    'normal',
    'high',
  ];
  
  // Currency Options
  static const List<String> currencyOptions = [
    'XAF', // Central African CFA franc
    'USD', // US Dollar
    'EUR', // Euro
  ];
  
  // Currency Symbols
  static const Map<String, String> currencySymbols = {
    'XAF': 'FCFA',
    'USD': '\$',
    'EUR': '€',
  };
  
  // Common FontAwesome icons for service categories
  static const List<String> commonIcons = [
    'fa-wrench', // Plomberie
    'fa-hammer', // Construction
    'fa-paint-brush', // Peinture
    'fa-bolt', // Électricité
    'fa-leaf', // Jardinage
    'fa-car', // Automobile
    'fa-home', // Maison
    'fa-users', // Services aux personnes
    'fa-laptop', // Informatique
    'fa-heart', // Santé
    'fa-graduation-cap', // Éducation
    'fa-utensils', // Restauration
    'fa-camera', // Photographie
    'fa-music', // Musique
    'fa-dumbbell', // Sport
    'fa-paw', // Animaux
    'fa-shield-alt', // Sécurité
    'fa-truck', // Transport
    'fa-phone', // Télécom
    'fa-dollar-sign', // Finance
  ];
  
  // Categorized icons for better organization
  static const Map<String, List<String>> iconCategories = {
    'Construction & Maintenance': [
      'fa-wrench',
      'fa-hammer',
      'fa-screwdriver',
      'fa-tools',
      'fa-hard-hat',
      'fa-paint-brush',
      'fa-paint-roller',
      'fa-bolt',
    ],
    'Technology': [
      'fa-laptop',
      'fa-mobile-alt',
      'fa-wifi',
      'fa-code',
      'fa-database',
      'fa-server',
      'fa-microchip',
    ],
    'Home & Garden': [
      'fa-home',
      'fa-leaf',
      'fa-seedling',
      'fa-tree',
      'fa-cut',
      'fa-couch',
    ],
    'Transportation': [
      'fa-car',
      'fa-truck',
      'fa-motorcycle',
      'fa-bicycle',
      'fa-plane',
      'fa-ship',
    ],
    'Health & Beauty': [
      'fa-heart',
      'fa-user-md',
      'fa-cut',
      'fa-spa',
      'fa-medkit',
    ],
    'Education & Training': [
      'fa-graduation-cap',
      'fa-book',
      'fa-chalkboard-teacher',
      'fa-school',
    ],
    'Business & Finance': [
      'fa-dollar-sign',
      'fa-chart-line',
      'fa-briefcase',
      'fa-handshake',
      'fa-calculator',
    ],
    'Entertainment': [
      'fa-music',
      'fa-camera',
      'fa-film',
      'fa-gamepad',
      'fa-theater-masks',
    ],
    'Sports & Fitness': [
      'fa-dumbbell',
      'fa-running',
      'fa-football-ball',
      'fa-swimmer',
    ],
    'Food & Restaurant': [
      'fa-utensils',
      'fa-coffee',
      'fa-wine-glass',
      'fa-pizza-slice',
    ],
  };

  // Error messages
  static const String networkErrorMessage = 'No internet connection. Please check your network and try again.';
  static const String serverErrorMessage = 'Server error occurred. Please try again later.';
  static const String unknownErrorMessage = 'An unexpected error occurred. Please try again.';
  static const String validationErrorMessage = 'Please check your input and try again.';
  
  // Success messages - Service Categories
  static const String createSuccessMessage = 'Service category created successfully';
  static const String updateSuccessMessage = 'Service category updated successfully';
  static const String deleteSuccessMessage = 'Service category deleted successfully';
  static const String statusToggleSuccessMessage = 'Service category status updated successfully';
  
  // Success messages - Job Offers
  static const String jobOfferCreateSuccessMessage = 'Job offer created successfully';
  static const String jobOfferUpdateSuccessMessage = 'Job offer updated successfully';
  static const String jobOfferDeleteSuccessMessage = 'Job offer deleted successfully';
  static const String jobOfferPublishSuccessMessage = 'Job offer published successfully';
  static const String jobOfferCancelSuccessMessage = 'Job offer cancelled successfully';
  static const String jobOfferStartSuccessMessage = 'Job offer started successfully';
  static const String jobOfferCompleteSuccessMessage = 'Job offer completed successfully';

  // Helper methods
  static String getIconCategoryName(String icon) {
    for (final entry in iconCategories.entries) {
      if (entry.value.contains(icon)) {
        return entry.key;
      }
    }
    return 'Other';
  }

  static List<String> getIconsForCategory(String categoryName) {
    return iconCategories[categoryName] ?? [];
  }

  static bool isValidIcon(String icon) {
    return commonIcons.contains(icon) || 
           iconCategories.values.any((icons) => icons.contains(icon));
  }

  static bool isValidSortBy(String sortBy) {
    return sortByOptions.contains(sortBy);
  }

  static bool isValidJobOfferSortBy(String sortBy) {
    return jobOfferSortByOptions.contains(sortBy);
  }

  static bool isValidSortOrder(String sortOrder) {
    return sortOrderOptions.contains(sortOrder);
  }
  
  static bool isValidJobOfferStatus(String status) {
    return jobOfferStatusOptions.contains(status);
  }
  
  static bool isValidJobOfferUrgency(String urgency) {
    return jobOfferUrgencyOptions.contains(urgency);
  }
  
  static bool isValidCurrency(String currency) {
    return currencyOptions.contains(currency);
  }
  
  static String getStatusLabel(String status) {
    return jobOfferStatusLabels[status] ?? status;
  }
  
  static String getUrgencyLabel(String urgency) {
    return jobOfferUrgencyLabels[urgency] ?? urgency;
  }
  
  static String getCurrencySymbol(String currency) {
    return currencySymbols[currency] ?? currency;
  }
  
  static String formatPrice(double price, String currency) {
    final symbol = getCurrencySymbol(currency);
    if (currency == 'XAF') {
      return '${price.toStringAsFixed(0)} $symbol';
    } else {
      return '$symbol${price.toStringAsFixed(2)}';
    }
  }
}