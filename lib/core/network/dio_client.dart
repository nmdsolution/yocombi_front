// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';

class DioClient {
  final Dio _dio;
  final Logger _logger = Logger();

  DioClient(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json; charset=utf-8',
        'Content-Type': 'application/json',
      },
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            _logger.d('🔍 Request path: ${options.path}');
            _logger.d('🛡️ Is auth endpoint: ${_isAuthEndpoint(options.path)}');

            // Only add token for non-auth endpoints
            if (!_isAuthEndpoint(options.path)) {
              final token = await SecureStorage.getToken();
              
              _logger.d('🔐 Retrieved token exists: ${token?.isNotEmpty ?? false}');

              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
                _logger.i('🔐 Token added to request');
              } else {
                _logger.w('⚠️ No token found in secure storage');
              }
            } else {
              _logger.i('🔓 Skipping token for auth endpoint: ${options.path}');
            }

            _logger.i('➡️ Request [${options.method}] → ${options.uri}');
            _logger.d('📤 Headers: ${options.headers}');
            handler.next(options);
          } catch (e, stackTrace) {
            _logger.e('❌ Error in onRequest interceptor: $e', error: e, stackTrace: stackTrace);
            handler.next(options); // Continue même si erreur
          }
        },

        onResponse: (response, handler) {
          _logger.i('✅ Response [${response.statusCode}] ← ${response.requestOptions.uri}');
          _logger.d('📥 Response body: ${response.data}');
          handler.next(response);
        },

        onError: (error, handler) {
          final status = error.response?.statusCode;
          final uri = error.requestOptions.uri;

          if (status == 401) {
            _logger.e('🔒 Unauthorized request → $uri');
            // You might want to trigger token refresh or logout here
          } else if (status == 403) {
            _logger.e('🚫 Forbidden request → $uri');
          } else if (status == 422) {
            _logger.e('📝 Validation error → $uri');
          } else if (status == 500) {
            _logger.e('🔥 Server error → $uri');
          }

          _logger.e('❌ Error [$status] ← $uri: ${error.message}');
          _logger.d('📥 Error response: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );

    _setupInterceptors();
  }

  Dio get dio => _dio;

  /// ✅ Better detection of public auth endpoints
  bool _isAuthEndpoint(String path) {
    final cleanPath = path.toLowerCase().replaceAll(RegExp(r'^/+'), '');
    
    final authEndpoints = [
      'auth/send-otp',
      'auth/verify-otp', 
      'auth/complete-registration',
      'auth/login',
      'auth/register',
      'auth/forgot-password',
      'auth/reset-password',
    ];
    
    return authEndpoints.any((endpoint) => cleanPath.endsWith(endpoint));
  }

  void _setupInterceptors() {
    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      maxStale: const Duration(days: 7),
    );

    _dio.interceptors.addAll([
      DioCacheInterceptor(options: cacheOptions),
    ]);
  }

  // Helper method to manually add auth header (if needed)
  void addAuthHeader(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Helper method to remove auth header
  void removeAuthHeader() {
    _dio.options.headers.remove('Authorization');
  }
}