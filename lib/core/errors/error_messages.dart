class ErrorMessageHandler {
  static String getFriendlyMessage({
    required int statusCode,
    String? serverMessage,
    String? defaultMessage,
  }) {
    // Prioritize server-provided message if available
    if (serverMessage != null && serverMessage.isNotEmpty) {
      return _cleanServerMessage(serverMessage);
    }

    // Use custom default if provided
    if (defaultMessage != null && defaultMessage.isNotEmpty) {
      return defaultMessage;
    }

    // Return status code specific messages
    return _getStatusCodeMessage(statusCode);
  }

  static String _cleanServerMessage(String message) {
    // Clean up common API response formats
    return message
        .replaceAll(RegExp(r'\[.*?\]'), '') // Remove [bracketed] technical details
        .replaceAll(RegExp(r'\{.*?\}'), '') // Remove {braced} technical details
        .trim();
  }

  static String _getStatusCodeMessage(int statusCode) {
    switch (statusCode) {
      // 4xx Client Errors
      case 400:
        return 'Your request couldn\'t be processed. Please check your input and try again.';
      case 401:
        return 'You need to sign in to access this. Please check your credentials.';
      case 402:
        return 'Payment required to access this feature.';
      case 403:
        return 'You don\'t have permission to perform this action.';
      case 404:
        return 'The requested resource wasn\'t found.';
      case 405:
        return 'This action isn\'t allowed.';
      case 406:
        return 'The server can\'t provide data in the requested format.';
      case 408:
        return 'Request took too long. Please check your connection and try again.';
      case 409:
        return 'There\'s a conflict with your request. Please try a different approach.';
      case 410:
        return 'The requested resource is no longer available.';
      case 411:
        return 'Your request needs a specified length.';
      case 412:
        return 'A required condition wasn\'t met.';
      case 413:
        return 'Your request is too large to process.';
      case 414:
        return 'The request URL is too long.';
      case 415:
        return 'Unsupported media type. Please try a different format.';
      case 416:
        return 'The requested range can\'t be satisfied.';
      case 417:
        return 'The server couldn\'t meet the expectation.';
      case 422:
        return 'We couldn\'t process your request. Please check for errors.';
      case 423:
        return 'The resource is locked.';
      case 424:
        return 'A dependent request failed.';
      case 425:
        return 'Too early to process this request.';
      case 426:
        return 'Upgrade required to access this feature.';
      case 428:
        return 'A precondition is required.';
      case 429:
        return 'You\'re making too many requests. Please slow down.';
      case 431:
        return 'Request headers are too large.';
      case 451:
        return 'Unavailable for legal reasons.';

      // 5xx Server Errors
      case 500:
        return 'We\'re having technical difficulties. Please try again later.';
      case 501:
        return 'This feature isn\'t implemented yet.';
      case 502:
        return 'Bad gateway. Our servers are having issues.';
      case 503:
        return 'Service temporarily unavailable. We\'re working on it!';
      case 504:
        return 'Gateway timeout. Please try again.';
      case 505:
        return 'HTTP version not supported.';
      case 506:
        return 'Variant also negotiates.';
      case 507:
        return 'Insufficient storage.';
      case 508:
        return 'Loop detected.';
      case 510:
        return 'Not extended.';
      case 511:
        return 'Network authentication required.';

      // Authentication-specific messages (could be 4xx or custom codes)
      case 1001:
        return 'Account not verified. Please check your email.';
      case 1002:
        return 'Invalid verification code. Please try again.';
      case 1003:
        return 'Session expired. Please sign in again.';
      case 1004:
        return 'Too many login attempts. Try again later.';
      case 1005:
        return 'Social login failed. Please try another method.';

      // Network/connection errors (typically statusCode = 0)
      case 0:
        return 'Connection failed. Please check your internet.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}