// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'authentification/providers/auth_provider.dart';
import 'job-offers/providers/job_offer_provider.dart';
import 'core/app/injection_container.dart' as di;
import 'core/app/app_admin.dart';
import 'service-categories/providers/service_category_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set clean URL strategy for Flutter Web
  setPathUrlStrategy();

  // Initialize dependencies
  await di.init();

  // Flutter error handling
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    print('Flutter Error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider - Must be first as others may depend on authentication
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => di.sl<AuthProvider>(),
          lazy: false, // Ensure AuthProvider is created immediately
        ),
        
        // Service Category Provider
        ChangeNotifierProvider<ServiceCategoryProvider>(
          create: (_) => di.sl<ServiceCategoryProvider>(),
          lazy: false,
        ),
        
        // Job Offer Provider
        ChangeNotifierProvider<JobOfferProvider>(
          create: (_) => di.sl<JobOfferProvider>(),
          lazy: false,
        ),
      ],
      child: const Yocombi(),
    );
  }
}