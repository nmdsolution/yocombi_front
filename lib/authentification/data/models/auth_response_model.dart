// lib/data/models/auth_response_model.dart
import '../../domain/entities/user.dart';

class AuthResponseModel {
  final String message;
  final User user;
  final String token;
  final String tokenType;
  final int expiresIn;

  AuthResponseModel({
    required this.message,
    required this.user,
    required this.token,
    required this.tokenType,
    required this.expiresIn,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'] as String? ?? '',
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String? ?? '', 
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int? ?? 3600,
    );
  }

  // Factory constructor for signup response (which might not have token)
  factory AuthResponseModel.fromSignupJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'] as String? ?? 'User created successfully',
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String? ?? '', // Signup might not return token
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int? ?? 3600,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
      'token': token,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }

  // Helper method to check if response has valid token
  bool get hasValidToken => token.isNotEmpty;

  // Create a copy with updated token (useful for refresh scenarios)
  AuthResponseModel copyWith({
    String? message,
    User? user,
    String? token,
    String? tokenType,
    int? expiresIn,
  }) {
    return AuthResponseModel(
      message: message ?? this.message,
      user: user ?? this.user,
      token: token ?? this.token,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }

  @override
  String toString() {
    return 'AuthResponseModel(message: $message, user: ${user.toString()}, hasToken: ${hasValidToken})';
  }
}