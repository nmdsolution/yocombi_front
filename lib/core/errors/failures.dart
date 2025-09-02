// lib/core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  final String userFriendlyMessage;

  const Failure({
    required this.message,
    this.statusCode,
    required this.userFriendlyMessage,
  });

  @override
  List<Object?> get props => [message, statusCode, userFriendlyMessage];
}

class ServerFailure extends Failure {
  @override
  final int statusCode;

  ServerFailure({
    required super.message,
    required this.statusCode,
    String? userFriendlyMessage,
  }) : super(
         statusCode: statusCode,
         userFriendlyMessage:
             userFriendlyMessage ?? getDefaultMessage(statusCode, ""),
       );
}

String getDefaultMessage(int code, String? serverMessage) {
  switch (code) {
    case 400:
      return 'Invalid request. Please check your input.';
    case 401:
      return 'Authentication failed. Please login again.';
    case 403:
      return 'You don\'t have permission for this action.';
    case 404:
      return 'Resource not found.';
    case 422:
      return 'Validation failed. Please correct the errors and try again.';
    case 429:
      return 'Too many requests. Please wait and try again later.';
    case 500:
      return 'Server error. Please try again later.';
    case 502:
      return 'Bad gateway. Please try again later.';
    case 503:
      return 'Service unavailable. Please try again later.';
    case 504:
      return 'Gateway timeout. Please try again later.';
    default:
      return 'Something went wrong (Error $code). Please try again.';
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure()
    : super(
        message: 'No internet connection',
        userFriendlyMessage:
            'Please check your internet connection and try again.',
      );
}

class ValidationFailure extends Failure {
  const ValidationFailure(String field, String message)
    : super(
        message: 'Validation failed for $field: $message',
        userFriendlyMessage: 'Please check your $field and try again.',
      );
}

class CacheFailure extends Failure {
  const CacheFailure()
    : super(
        message: 'Cache operation failed',
        userFriendlyMessage:
            'We encountered a local storage issue. Please restart the app.',
      );
}

class TokenRefreshFailure extends Failure {
  const TokenRefreshFailure(String message)
    : super(
        message: 'Token refresh operation failed',
        userFriendlyMessage:
            'We encountered an issue. Please restart your session.s',
      );
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});
}
