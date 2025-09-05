// lib/core/routes/db_app_route.dart (Final Update)
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../authentification/presentation/web/profile/user_dashboard_page.dart';
import '../../authentification/presentation/web/signIn/signin_form_page.dart';
import '../../authentification/presentation/web/signUp/complete_registration_page_web.dart';
import '../../authentification/presentation/web/signUp/signup_form_page.dart';

import '../../demandeur/presentation/screen/demandeur_dashboard_page.dart';
import '../../demandeur/presentation/screen/demandeur_settings_page.dart';
import '../../demandeur/presentation/screen/my_job_requests_page.dart';
import '../../demandeur/presentation/screen/new_demande_page.dart';
import '../../demandeur/presentation/screen/edit_demande_page.dart';
import '../../demandeur/presentation/screen/published_demandes_page.dart'; // New import
import '../../home/presentation/home_page.dart';
import '../../presentation/splash/welcome_screen.dart';
import '../../travailleur/presentation/screen/dashboard_page.dart';
import '../middlewares/db_route_middleware.dart';
import '../routes/routes.dart';

class DbAppRoute {
  static final List<GetPage> pages = [
    // ========== CORE ROUTES ==========
    GetPage(
      name: AppRoutes.splash,
      page: () => const WelcomeScreen(),
    ),
       
    GetPage(
      name: AppRoutes.signin,
      page: () => const SigninFormPageWeb(),
      middlewares: [DbRouteMiddleware()],
    ),
       
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      middlewares: [DbRouteMiddleware()],
    ),
       
    // Legacy dashboard route - redirects to travailleur dashboard
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      middlewares: [DbRouteMiddleware()],
    ),
       
    // ========== TRAVAILLEUR ROUTES ==========
    GetPage(
      name: AppRoutes.travailleurDashboard,
      page: () => const DashboardPage(),
      middlewares: [DbRouteMiddleware()],
    ),
            
    GetPage(
      name: AppRoutes.travailleurNewMission,
      page: () => const Scaffold(
        body: Center(
          child: Text('Nouvelle Mission - Coming Soon'),
        ),
      ),
      middlewares: [DbRouteMiddleware()],
    ),
       
    // ========== DEMANDEUR ROUTES ==========
    GetPage(
      name: AppRoutes.demandeurDashboard,
      page: () => const DemandeurDashboardPage(),
      middlewares: [DbRouteMiddleware()],
    ),
        
    GetPage(
      name: AppRoutes.mesDemande,
      page: () => const MesDemandePage(),
      middlewares: [DbRouteMiddleware()],
    ),
    
    GetPage(
      name: AppRoutes.newmDemande,
      page: () => const NewmDemandePage(),
      middlewares: [DbRouteMiddleware()],
    ),
    
    // Edit Demande Route with parameter
    GetPage(
      name: '${AppRoutes.editDemande}/:jobOfferId',
      page: () {
        final jobOfferId = Get.parameters['jobOfferId'] ?? '';
        return EditDemandePage(jobOfferId: jobOfferId);
      },
      middlewares: [DbRouteMiddleware()],
    ),
    
    // NEW: Published Demandes Route
    GetPage(
      name: AppRoutes.publishedDemandes,
      page: () => const PublishedDemandesPage(),
      middlewares: [DbRouteMiddleware()],
    ),
        
    GetPage(
      name: AppRoutes.demandeurSettings,
      page: () => const DemandeurSettingsPage(),
      middlewares: [DbRouteMiddleware()],
    ),
       
    // ========== USER MANAGEMENT ROUTES ==========
    GetPage(
      name: AppRoutes.user,
      page: () => const UserDashboardPage(),
      middlewares: [DbRouteMiddleware()],
    ),
       
    GetPage(
      name: AppRoutes.profile,
      page: () => const Scaffold(
        body: Center(
          child: Text('Profile Page - Coming Soon'),
        ),
      ),
      middlewares: [DbRouteMiddleware()],
    ),
       
    GetPage(
      name: AppRoutes.signupForm,
      page: () => const SignupFormPageWeb(),
      middlewares: [DbRouteMiddleware()],
    ),
       
    GetPage(
      name: AppRoutes.completeRegistration,
      page: () => const CompleteRegistrationPageWeb(),
      middlewares: [DbRouteMiddleware()],
    ),
       
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const Scaffold(
        body: Center(
          child: Text('Forgot Password - Coming Soon'),
        ),
      ),
    ),
  ];
}