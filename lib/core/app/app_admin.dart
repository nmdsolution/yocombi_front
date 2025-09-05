import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../routes/db_app_route.dart';
import '../routes/routes.dart';
import '../theme/app_theme.dart';


class Yocombi extends StatelessWidget {
  const Yocombi({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return GetMaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          getPages: DbAppRoute.pages,
          initialRoute: AppRoutes.splash,
          unknownRoute: GetPage(
            name: '/page-not-found',
            page: () =>
                const Scaffold(body: Center(child: Text('Page not found'))),
          ),
        );
      },
    );
  }
}

// builder: (context, child) {
//             // Add global error handling
//             ErrorWidget.builder = (FlutterErrorDetails details) {
//               return ErrorPage(
//                 errorDetails: details,
//                 onRetry: () => context.go(AppRoutes.splash),
//               );
//             };
//             return child!;
//           },
