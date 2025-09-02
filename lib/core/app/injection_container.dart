// lib/core/app/injection_container.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Auth imports
import '../../authentification/data/datasources/auth_remote_data_source.dart';
import '../../authentification/data/repositories/auth_repository.dart';
import '../../authentification/domain/repositories/auth_repository_impl.dart';
import '../../authentification/domain/usecases/send_otp_usecase.dart';
import '../../authentification/domain/usecases/verify_otp_usecase.dart';
import '../../authentification/domain/usecases/complete_registration_usecase.dart';
import '../../authentification/domain/usecases/refresh_token_usecase.dart';
import '../../authentification/providers/auth_provider.dart';
import '../../authentification/domain/usecases/login_usecase.dart';

// Service Categories imports
import '../../job-offers/domain/repositories/job_offer_repository_impl.dart';
import '../../job-offers/domain/usecases/Cancel_Joboffer_usecase.dart';
import '../../job-offers/domain/usecases/Create_Joboffer_usecase.dart';
import '../../job-offers/domain/usecases/Start_Joboffer_usecase.dart';
import '../../job-offers/domain/usecases/complete_Joboffer_usecase.dart';
import '../../job-offers/domain/usecases/delete_Joboffer_usecase.dart';
import '../../job-offers/domain/usecases/get_Joboffer_usecase.dart';
import '../../job-offers/domain/usecases/get_Joboffers_by_category_usecase.dart';
import '../../job-offers/domain/usecases/get_Joboffers_by_location_usecase.dart';
import '../../job-offers/domain/usecases/get_myJoboffers_usecase.dart';
import '../../job-offers/domain/usecases/get_mystatistics_usecase.dart';
import '../../job-offers/domain/usecases/get_paginated_Joboffers_usecase.dart';
import '../../job-offers/domain/usecases/get_public_statistics.usecase.dart';
import '../../job-offers/domain/usecases/get_recent_Joboffers_usecase.dart';
import '../../job-offers/domain/usecases/getfeatured_Joboffers_usecase.dart';
import '../../job-offers/domain/usecases/partial_updateJoboffer_usecase.dart';
import '../../job-offers/domain/usecases/publish_Joboffer_usecase.dart';
import '../../job-offers/domain/usecases/search_Joboffers_usecase.dart';
import '../../job-offers/domain/usecases/update_Joboffer_usecase.dart';
import '../../job-offers/providers/job_offer_provider.dart';
import '../../service-categories/data/datasources/service_category_remote_data_source.dart';
import '../../service-categories/data/repositories/service_category_repository.dart';
import '../../service-categories/domain/repositories/service_category_repository_impl.dart';
import '../../service-categories/domain/usecases/service_category_usecases.dart';

// Job Offers imports
import '../../job-offers/data/datasources/job_offer_remote_data_source.dart';
import '../../job-offers/data/repositories/job_offer_repository.dart';
import '../../job-offers/domain/usecases/job_offer_usecases.dart';


// Core imports
import '../../service-categories/providers/service_category_provider.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../services/token_refresh_service.dart';
import '../services/cache_manager.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => http.Client());

  // Register Dio FIRST
  sl.registerLazySingleton<Dio>(() => Dio());

  // Core components
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => DioClient(sl<Dio>()));
  sl.registerLazySingleton(() => TokenRefreshService());
  sl.registerLazySingleton<CacheManager>(() => CacheManagerImpl(sl()));

  // ========== DATA SOURCES ==========

  // Auth Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Service Category Data Sources
  sl.registerLazySingleton<ServiceCategoryRemoteDataSource>(
    () => ServiceCategoryRemoteDataSourceImpl(sl()),
  );

  // Job Offer Data Sources
  sl.registerLazySingleton<JobOfferRemoteDataSource>(
    () => JobOfferRemoteDataSourceImpl(sl()),
  );

  // ========== REPOSITORIES ==========

  // Auth Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      client: sl(),
    ),
  );

  // Service Category Repositories
  sl.registerLazySingleton<ServiceCategoryRepository>(
    () => ServiceCategoryRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      cacheManager: sl(),
    ),
  );

  // Job Offer Repositories
  sl.registerLazySingleton<JobOfferRepository>(
    () => JobOfferRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      cacheManager: sl(),
    ),
  );

  // ========== USE CASES ==========

  // Auth Use Cases
  sl.registerLazySingleton(() => SendOtpUsecase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUsecase(sl()));
  sl.registerLazySingleton(() => CompleteRegistrationUsecase(sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase(sl()));
  sl.registerLazySingleton(() => LoginUsecase(sl()));

  // Service Category Use Cases
  sl.registerLazySingleton(() => GetServiceCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetServiceCategoryUseCase(sl()));
  sl.registerLazySingleton(() => CreateServiceCategoryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateServiceCategoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteServiceCategoryUseCase(sl()));
  sl.registerLazySingleton(() => ToggleServiceCategoryStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetActiveServiceCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => SearchServiceCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetPaginatedServiceCategoriesUseCase(sl()));

  // Job Offer Use Cases
  sl.registerLazySingleton(() => GetJobOffersUseCase(sl()));
  sl.registerLazySingleton(() => GetJobOfferUseCase(sl()));
  sl.registerLazySingleton(() => CreateJobOfferUseCase(sl()));
  sl.registerLazySingleton(() => UpdateJobOfferUseCase(sl()));
  sl.registerLazySingleton(() => PartialUpdateJobOfferUseCase(sl()));
  sl.registerLazySingleton(() => DeleteJobOfferUseCase(sl()));
  sl.registerLazySingleton(() => PublishJobOfferUseCase(sl()));
  sl.registerLazySingleton(() => CancelJobOfferUseCase(sl()));
  sl.registerLazySingleton(() => StartJobOfferUseCase(sl()));
  sl.registerLazySingleton(() => CompleteJobOfferUseCase(sl()));
  sl.registerLazySingleton(() => SearchJobOffersUseCase(sl()));
  sl.registerLazySingleton(() => GetFeaturedJobOffersUseCase(sl()));
  sl.registerLazySingleton(() => GetRecentJobOffersUseCase(sl()));
  sl.registerLazySingleton(() => GetJobOffersByCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetJobOffersByLocationUseCase(sl()));
  sl.registerLazySingleton(() => GetMyJobOffersUseCase(sl()));
  sl.registerLazySingleton(() => GetMyStatisticsUseCase(sl()));
  sl.registerLazySingleton(() => GetPublicStatisticsUseCase(sl()));
  sl.registerLazySingleton(() => GetPaginatedJobOffersUseCase(sl()));

  // ========== PROVIDERS ==========

  // Auth Providers
  sl.registerLazySingleton<AuthProvider>(() {
    return AuthProvider(
      sendOtpUsecase: sl(),
      verifyOtpUsecase: sl(),
      completeRegistrationUsecase: sl(),
      authRepository: sl(),
      refreshTokenUseCase: sl(),
      tokenRefreshService: sl(),
      loginUsecase: sl(),
    );
  });

  // Service Category Providers
  sl.registerLazySingleton<ServiceCategoryProvider>(() {
    return ServiceCategoryProvider(sl());
  });

  // Job Offer Providers
  sl.registerLazySingleton<JobOfferProvider>(() {
    return JobOfferProvider(sl());
  });
}