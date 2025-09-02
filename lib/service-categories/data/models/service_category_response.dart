// lib/domain/entities/service_category_response.dart
import '../../domain/entities/service_category.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
      'status': status,
    };
  }

  ServiceCategoryResponse copyWith({
    String? message,
    ServiceCategory? data,
    String? status,
  }) {
    return ServiceCategoryResponse(
      message: message ?? this.message,
      data: data ?? this.data,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'ServiceCategoryResponse(message: $message, data: ${data.toString()}, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ServiceCategoryResponse &&
        other.message == message &&
        other.data == data &&
        other.status == status;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        data.hashCode ^
        status.hashCode;
  }
}