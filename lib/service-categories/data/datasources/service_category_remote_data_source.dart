// lib/data/datasources/service_category_remote_data_source.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_category_request.dart';

abstract class ServiceCategoryRemoteDataSource {
  Future<ServiceCategoryListResponse> getServiceCategories([ServiceCategoryQuery? query]);
  Future<ServiceCategory> getServiceCategory(String id);
  Future<ServiceCategory> createServiceCategory(ServiceCategoryRequest request);
  Future<ServiceCategory> updateServiceCategory(String id, ServiceCategoryRequest request);
  Future<void> deleteServiceCategory(String id);
  Future<ServiceCategory> toggleServiceCategoryStatus(String id);
}

class ServiceCategoryRemoteDataSourceImpl implements ServiceCategoryRemoteDataSource {
  final DioClient dioClient;
  static const String _baseEndpoint = '/service-categories';

  ServiceCategoryRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ServiceCategoryListResponse> getServiceCategories([ServiceCategoryQuery? query]) async {
    try {
      print('Fetching service categories with query: ${query?.toString()}');

      // Build URL with query parameters
      String endpoint = _baseEndpoint;
      if (query != null) {
        final queryParams = query.toQueryParams();
        if (queryParams.isNotEmpty) {
          final queryString = queryParams.entries
              .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
              .join('&');
          endpoint = '$_baseEndpoint?$queryString';
        }
      }

      print('Request endpoint: $endpoint');

      final response = await dioClient.dio.get(
        endpoint,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Get service categories response status: ${response.statusCode}');
      print('Get service categories response data: ${response.data}');

      if (response.statusCode == 200) {
        return ServiceCategoryListResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to fetch service categories';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in getServiceCategories: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch service categories';
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? errorMessage;
        }
      }

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: errorMessage,
        error: e.error,
        type: e.type,
      );
    } catch (e) {
      print('General error in getServiceCategories: $e');
      throw DioException(
        requestOptions: RequestOptions(path: _baseEndpoint),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<ServiceCategory> getServiceCategory(String id) async {
    try {
      print('Fetching service category with ID: $id');

      final response = await dioClient.dio.get(
        '$_baseEndpoint/$id',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Get service category response status: ${response.statusCode}');
      print('Get service category response data: ${response.data}');

      if (response.statusCode == 200) {
        final serviceResponse = ServiceCategoryResponse.fromJson(response.data as Map<String, dynamic>);
        return serviceResponse.data;
      } else {
        final errorMessage = response.data['message'] ?? 'Service category not found';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in getServiceCategory: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Service category not found';
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? errorMessage;
        }
      }

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: errorMessage,
        error: e.error,
        type: e.type,
      );
    } catch (e) {
      print('General error in getServiceCategory: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/$id'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<ServiceCategory> createServiceCategory(ServiceCategoryRequest request) async {
    try {
      print('Creating service category with data: ${request.toString()}');

      final requestData = request.toJson();
      print('Create service category request data: $requestData');

      final response = await dioClient.dio.post(
        _baseEndpoint,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('Create service category response status: ${response.statusCode}');
      print('Create service category response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final serviceResponse = ServiceCategoryResponse.fromJson(response.data as Map<String, dynamic>);
        return serviceResponse.data;
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to create service category';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in createServiceCategory: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to create service category';
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? errorMessage;
        }
      }

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: errorMessage,
        error: e.error,
        type: e.type,
      );
    } catch (e) {
      print('General error in createServiceCategory: $e');
      throw DioException(
        requestOptions: RequestOptions(path: _baseEndpoint),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<ServiceCategory> updateServiceCategory(String id, ServiceCategoryRequest request) async {
    try {
      print('Updating service category with ID: $id, data: ${request.toString()}');

      final requestData = request.toJson();
      print('Update service category request data: $requestData');

      final response = await dioClient.dio.put(
        '$_baseEndpoint/$id',
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('Update service category response status: ${response.statusCode}');
      print('Update service category response data: ${response.data}');

      if (response.statusCode == 200) {
        final serviceResponse = ServiceCategoryResponse.fromJson(response.data as Map<String, dynamic>);
        return serviceResponse.data;
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to update service category';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in updateServiceCategory: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to update service category';
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? errorMessage;
        }
      }

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: errorMessage,
        error: e.error,
        type: e.type,
      );
    } catch (e) {
      print('General error in updateServiceCategory: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/$id'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<void> deleteServiceCategory(String id) async {
    try {
      print('Deleting service category with ID: $id');

      final response = await dioClient.dio.delete(
        '$_baseEndpoint/$id',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Delete service category response status: ${response.statusCode}');
      print('Delete service category response data: ${response.data}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorMessage = response.data['message'] ?? 'Failed to delete service category';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in deleteServiceCategory: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to delete service category';
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? errorMessage;
        }
      }

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: errorMessage,
        error: e.error,
        type: e.type,
      );
    } catch (e) {
      print('General error in deleteServiceCategory: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/$id'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<ServiceCategory> toggleServiceCategoryStatus(String id) async {
    try {
      print('Toggling service category status for ID: $id');

      final response = await dioClient.dio.patch(
        '$_baseEndpoint/$id/toggle-status',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Toggle service category status response status: ${response.statusCode}');
      print('Toggle service category status response data: ${response.data}');

      if (response.statusCode == 200) {
        final serviceResponse = ServiceCategoryResponse.fromJson(response.data as Map<String, dynamic>);
        return serviceResponse.data;
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to toggle service category status';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in toggleServiceCategoryStatus: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to toggle service category status';
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? errorMessage;
        }
      }

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: errorMessage,
        error: e.error,
        type: e.type,
      );
    } catch (e) {
      print('General error in toggleServiceCategoryStatus: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/$id/toggle-status'),
        message: e.toString(),
        error: e,
      );
    }
  }
}