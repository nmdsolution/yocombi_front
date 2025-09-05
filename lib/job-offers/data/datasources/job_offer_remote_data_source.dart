// lib/data/datasources/job_offer_remote_data_source.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../domain/entities/job_offer.dart';
import '../../domain/entities/job_offer_request.dart';

abstract class JobOfferRemoteDataSource {
  Future<JobOfferListResponse> getJobOffers([JobOfferQuery? query]);
  Future<JobOffer> getJobOffer(String id);
  Future<JobOffer> createJobOffer(JobOfferRequest request);
  Future<JobOffer> updateJobOffer(String id, JobOfferRequest request);
  Future<JobOffer> partialUpdateJobOffer(String id, JobOfferRequest request);
  Future<void> deleteJobOffer(String id);
  Future<JobOffer> publishJobOffer(String id);
  Future<JobOffer> cancelJobOffer(String id);
  Future<JobOffer> startJobOffer(String id);
  Future<JobOffer> completeJobOffer(String id);
  Future<JobOfferListResponse> searchJobOffers(Map<String, dynamic> params);
  Future<JobOfferListResponse> getFeaturedJobOffers([int? page, int? perPage]);
  Future<JobOfferListResponse> getRecentJobOffers([int? page, int? perPage]);
  Future<JobOfferListResponse> getJobOffersByCategory(String categoryId, [int? page, int? perPage]);
  Future<JobOfferListResponse> getJobOffersByLocation(Map<String, dynamic> params);
  Future<JobOfferListResponse> getMyJobOffers([JobOfferQuery? query]);
  Future<UserStats> getMyStatistics();
  Future<PublicStats> getPublicStatistics();
}

class JobOfferRemoteDataSourceImpl implements JobOfferRemoteDataSource {
  final DioClient dioClient;
  static const String _baseEndpoint = '/job-offers';

  JobOfferRemoteDataSourceImpl(this.dioClient);

  @override
  Future<JobOfferListResponse> getJobOffers([JobOfferQuery? query]) async {
    try {
      print('Fetching job offers with query: ${query?.toString()}');

      // Build URL with query parameters
      String endpoint = _baseEndpoint;
      if (query != null) {
        final queryParams = query.toQueryParams();
        if (queryParams.isNotEmpty) {
          final queryString = queryParams.entries
              .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
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

      print('Get job offers response status: ${response.statusCode}');
      print('Get job offers response data: ${response.data}');

      if (response.statusCode == 200) {
        return JobOfferListResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to fetch job offers';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in getJobOffers: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch job offers';
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
      print('General error in getJobOffers: $e');
      throw DioException(
        requestOptions: RequestOptions(path: _baseEndpoint),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<JobOffer> getJobOffer(String id) async {
    try {
      print('Fetching job offer with ID: $id');

      final response = await dioClient.dio.get(
        '$_baseEndpoint/$id',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Get job offer response status: ${response.statusCode}');
      print('Get job offer response data: ${response.data}');

      if (response.statusCode == 200) {
        final jobOfferResponse = JobOfferResponse.fromJson(response.data as Map<String, dynamic>);
        return jobOfferResponse.data;
      } else {
        final errorMessage = response.data['message'] ?? 'Job offer not found';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in getJobOffer: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Job offer not found';
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
      print('General error in getJobOffer: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/$id'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<JobOffer> createJobOffer(JobOfferRequest request) async {
    try {
      print('Creating job offer with data: ${request.toString()}');

      final requestData = request.toJson();
      print('Create job offer request data: $requestData');

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

      print('Create job offer response status: ${response.statusCode}');
      print('Create job offer response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jobOfferResponse = JobOfferResponse.fromJson(response.data as Map<String, dynamic>);
        return jobOfferResponse.data;
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to create job offer';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in createJobOffer: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to create job offer';
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
      print('General error in createJobOffer: $e');
      throw DioException(
        requestOptions: RequestOptions(path: _baseEndpoint),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<JobOffer> updateJobOffer(String id, JobOfferRequest request) async {
    try {
      print('Updating job offer with ID: $id, data: ${request.toString()}');

      final requestData = request.toJson();
      print('Update job offer request data: $requestData');

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

      print('Update job offer response status: ${response.statusCode}');
      print('Update job offer response data: ${response.data}');

      if (response.statusCode == 200) {
        final jobOfferResponse = JobOfferResponse.fromJson(response.data as Map<String, dynamic>);
        return jobOfferResponse.data;
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to update job offer';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in updateJobOffer: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to update job offer';
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
      print('General error in updateJobOffer: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/$id'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<JobOffer> partialUpdateJobOffer(String id, JobOfferRequest request) async {
    try {
      print('Partially updating job offer with ID: $id, data: ${request.toString()}');

      final requestData = request.toJson();
      print('Partial update job offer request data: $requestData');

      final response = await dioClient.dio.patch(
        '$_baseEndpoint/$id',
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('Partial update job offer response status: ${response.statusCode}');
      print('Partial update job offer response data: ${response.data}');

      if (response.statusCode == 200) {
        final jobOfferResponse = JobOfferResponse.fromJson(response.data as Map<String, dynamic>);
        return jobOfferResponse.data;
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to update job offer';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in partialUpdateJobOffer: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to update job offer';
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
      print('General error in partialUpdateJobOffer: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/$id'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<void> deleteJobOffer(String id) async {
    try {
      print('Deleting job offer with ID: $id');

      final response = await dioClient.dio.delete(
        '$_baseEndpoint/$id',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Delete job offer response status: ${response.statusCode}');
      print('Delete job offer response data: ${response.data}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorMessage = response.data['message'] ?? 'Failed to delete job offer';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in deleteJobOffer: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to delete job offer';
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
      print('General error in deleteJobOffer: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/$id'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<JobOffer> publishJobOffer(String id) async {
    return _changeJobOfferStatus(id, 'publish');
  }

  @override
  Future<JobOffer> cancelJobOffer(String id) async {
    return _changeJobOfferStatus(id, 'cancel');
  }

  @override
  Future<JobOffer> startJobOffer(String id) async {
    return _changeJobOfferStatus(id, 'start');
  }

  @override
  Future<JobOffer> completeJobOffer(String id) async {
    return _changeJobOfferStatus(id, 'complete');
  }

  Future<JobOffer> _changeJobOfferStatus(String id, String action) async {
    try {
      print('Changing job offer status to $action for ID: $id');

      final response = await dioClient.dio.patch(
        '$_baseEndpoint/$id/$action',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Change job offer status response status: ${response.statusCode}');
      print('Change job offer status response data: ${response.data}');

      if (response.statusCode == 200) {
        final jobOfferResponse = JobOfferResponse.fromJson(response.data as Map<String, dynamic>);
        return jobOfferResponse.data;
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to $action job offer';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in _changeJobOfferStatus($action): ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to $action job offer';
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
      print('General error in _changeJobOfferStatus($action): $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/$id/$action'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<JobOfferListResponse> searchJobOffers(Map<String, dynamic> params) async {
    try {
      print('Searching job offers with params: $params');

      final queryString = params.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');
      final endpoint = '$_baseEndpoint/search?$queryString';

      print('Search endpoint: $endpoint');

      final response = await dioClient.dio.get(
        endpoint,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Search job offers response status: ${response.statusCode}');
      print('Search job offers response data: ${response.data}');

      if (response.statusCode == 200) {
        return JobOfferListResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to search job offers';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in searchJobOffers: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to search job offers';
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
      print('General error in searchJobOffers: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/search'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<JobOfferListResponse> getFeaturedJobOffers([int? page, int? perPage]) async {
    try {
      print('Fetching featured job offers - page: $page, perPage: $perPage');

      String endpoint = '$_baseEndpoint/featured';
      final params = <String, String>{};
      
      if (page != null) params['page'] = page.toString();
      if (perPage != null) params['per_page'] = perPage.toString();
      
      if (params.isNotEmpty) {
        final queryString = params.entries
            .map((e) => '${e.key}=${e.value}')
            .join('&');
        endpoint = '$endpoint?$queryString';
      }

      print('Featured endpoint: $endpoint');

      final response = await dioClient.dio.get(
        endpoint,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Get featured job offers response status: ${response.statusCode}');
      print('Get featured job offers response data: ${response.data}');

      if (response.statusCode == 200) {
        return JobOfferListResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to fetch featured job offers';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in getFeaturedJobOffers: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch featured job offers';
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
      print('General error in getFeaturedJobOffers: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/featured'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<JobOfferListResponse> getRecentJobOffers([int? page, int? perPage]) async {
    try {
      print('Fetching recent job offers - page: $page, perPage: $perPage');

      String endpoint = '$_baseEndpoint/recent';
      final params = <String, String>{};
      
      if (page != null) params['page'] = page.toString();
      if (perPage != null) params['per_page'] = perPage.toString();
      
      if (params.isNotEmpty) {
        final queryString = params.entries
            .map((e) => '${e.key}=${e.value}')
            .join('&');
        endpoint = '$endpoint?$queryString';
      }

      print('Recent endpoint: $endpoint');

      final response = await dioClient.dio.get(
        endpoint,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Get recent job offers response status: ${response.statusCode}');
      print('Get recent job offers response data: ${response.data}');

      if (response.statusCode == 200) {
        return JobOfferListResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to fetch recent job offers';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in getRecentJobOffers: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch recent job offers';
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
      print('General error in getRecentJobOffers: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/recent'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<JobOfferListResponse> getJobOffersByCategory(String categoryId, [int? page, int? perPage]) async {
    try {
      print('Fetching job offers by category: $categoryId - page: $page, perPage: $perPage');

      String endpoint = '$_baseEndpoint/category/$categoryId';
      final params = <String, String>{};
      
      if (page != null) params['page'] = page.toString();
      if (perPage != null) params['per_page'] = perPage.toString();
      
      if (params.isNotEmpty) {
        final queryString = params.entries
            .map((e) => '${e.key}=${e.value}')
            .join('&');
        endpoint = '$endpoint?$queryString';
      }

      print('Category endpoint: $endpoint');

      final response = await dioClient.dio.get(
        endpoint,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Get job offers by category response status: ${response.statusCode}');
      print('Get job offers by category response data: ${response.data}');

      if (response.statusCode == 200) {
        return JobOfferListResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to fetch job offers by category';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in getJobOffersByCategory: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch job offers by category';
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
      print('General error in getJobOffersByCategory: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/category/$categoryId'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<JobOfferListResponse> getJobOffersByLocation(Map<String, dynamic> params) async {
    try {
      print('Fetching job offers by location with params: $params');

      final latitude = params['latitude'];
      final longitude = params['longitude'];
      
      String endpoint = '$_baseEndpoint/location/$latitude/$longitude';
      final queryParams = Map<String, String>.from(params);
      queryParams.remove('latitude');
      queryParams.remove('longitude');
      
      if (queryParams.isNotEmpty) {
        final queryString = queryParams.entries
            .map((e) => '${e.key}=${e.value}')
            .join('&');
        endpoint = '$endpoint?$queryString';
      }

      print('Location endpoint: $endpoint');

      final response = await dioClient.dio.get(
        endpoint,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Get job offers by location response status: ${response.statusCode}');
      print('Get job offers by location response data: ${response.data}');

      if (response.statusCode == 200) {
        return JobOfferListResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to fetch job offers by location';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in getJobOffersByLocation: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch job offers by location';
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
      print('General error in getJobOffersByLocation: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/location'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<JobOfferListResponse> getMyJobOffers([JobOfferQuery? query]) async {
    try {
      print('Fetching my job offers with query: ${query?.toString()}');

      String endpoint = '$_baseEndpoint/user/my-jobs';
      if (query != null) {
        final queryParams = query.toQueryParams();
        if (queryParams.isNotEmpty) {
          final queryString = queryParams.entries
              .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
              .join('&');
          endpoint = '$endpoint?$queryString';
        }
      }

      print('My jobs endpoint: $endpoint');

      final response = await dioClient.dio.get(
        endpoint,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Get my job offers response status: ${response.statusCode}');
      print('Get my job offers response data: ${response.data}');

      if (response.statusCode == 200) {
        return JobOfferListResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to fetch my job offers';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in getMyJobOffers: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch my job offers';
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
      print('General error in getMyJobOffers: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/user/my-jobs'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<UserStats> getMyStatistics() async {
    try {
      print('Fetching my statistics');

      final response = await dioClient.dio.get(
        '$_baseEndpoint/user/stats',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Get my statistics response status: ${response.statusCode}');
      print('Get my statistics response data: ${response.data}');

      if (response.statusCode == 200) {
        final statsResponse = UserStatsResponse.fromJson(response.data as Map<String, dynamic>);
        return statsResponse.data;
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to fetch statistics';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in getMyStatistics: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch statistics';
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
      print('General error in getMyStatistics: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/user/stats'),
        message: e.toString(),
        error: e,
      );
    }
  }

  @override
  Future<PublicStats> getPublicStatistics() async {
    try {
      print('Fetching public statistics');

      final response = await dioClient.dio.get(
        '$_baseEndpoint/stats',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Get public statistics response status: ${response.statusCode}');
      print('Get public statistics response data: ${response.data}');

      if (response.statusCode == 200) {
        final statsResponse = PublicStatsResponse.fromJson(response.data as Map<String, dynamic>);
        return statsResponse.data;
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to fetch public statistics';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          error: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('DioException in getPublicStatistics: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch public statistics';
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
      print('General error in getPublicStatistics: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseEndpoint/stats'),
        message: e.toString(),
        error: e,
      );
    }
  }
}