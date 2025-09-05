// lib/core/middlewares/db_route_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../authentification/providers/auth_provider.dart';
import '../../core/enums/enums.dart';
import '../app/injection_container.dart' as di;
import '../routes/routes.dart';

class DbRouteMiddleware extends GetMiddleware {
  @override
  int? priority = 1;

  @override
  RouteSettings? redirect(String? route) {
    try {
      // Get AuthProvider from dependency injection
      final authProvider = di.sl<AuthProvider>();
      final isAuthenticated = authProvider.isAuthenticated;
      final authState = authProvider.state;
      final currentType = authProvider.currentType;
      final currentIdentifier = authProvider.currentIdentifier;

      print('Route Middleware: route=$route, isAuthenticated=$isAuthenticated, authState=$authState, currentType=$currentType');

      // Define protected routes
      final protectedRoutes = [
        AppRoutes.home,
        AppRoutes.user,
        AppRoutes.profile,
      ];

      // Define public routes (accessible without authentication)
      final publicRoutes = [
        AppRoutes.signin,
        AppRoutes.signupForm,
        AppRoutes.forgotPassword,
        AppRoutes.splash,
      ];

      // Define registration flow routes (accessible during registration process)
      final registrationFlowRoutes = [
        AppRoutes.completeRegistration,
      ];

      // Welcome/splash screen should always be accessible - no restrictions
      if (route == AppRoutes.splash) {
        print('Allowing access to welcome screen');
        return null;
      }

      // If user is fully authenticated, handle accordingly
      if (isAuthenticated && authState == AuthState.success) {
        // Redirect authenticated users away from auth pages
        if (publicRoutes.contains(route) || registrationFlowRoutes.contains(route)) {
          print('Redirecting authenticated user to home');
          return RouteSettings(name: AppRoutes.home);
        }
        
        // Allow access to protected routes
        if (protectedRoutes.contains(route)) {
          print('Allowing authenticated user access to protected route');
          return null;
        }
      }

      // Handle registration flow routes
      if (registrationFlowRoutes.contains(route)) {
        // Check if user has a valid registration session
        if (currentIdentifier != null && 
            currentType == 'register' &&
            (authState == AuthState.otpVerified || 
             authState == AuthState.otpSent ||
             authState == AuthState.loading)) {
          print('Allowing access to registration flow route - valid session');
          return null;
        } else if (isAuthenticated && authState == AuthState.success) {
          // User completed registration and is now authenticated
          print('User completed registration, redirecting to home');
          return RouteSettings(name: AppRoutes.home);
        } else {
          print('Redirecting to signup - invalid registration session');
          return RouteSettings(name: AppRoutes.signupForm);
        }
      }

      // If user is not authenticated and trying to access protected routes
      if (!isAuthenticated && protectedRoutes.contains(route)) {
        print('Redirecting to welcome screen - not authenticated for protected route');
        return RouteSettings(name: AppRoutes.splash);
      }

      // If user is loading or in error state, allow access to public routes
      if ((authState == AuthState.loading || authState == AuthState.error) && 
          publicRoutes.contains(route)) {
        print('Allowing access to public route during loading/error state');
        return null;
      }

      // If user has an active auth flow but trying to access signin/signup
      if (!isAuthenticated && 
          (authState == AuthState.otpSent || authState == AuthState.otpVerified)) {
        if (currentType == 'register' && route == AppRoutes.signupForm) {
          // Allow staying on signup form during registration flow
          print('Allowing access to signup during registration flow');
          return null;
        } else if (currentType == 'login' && route == AppRoutes.signin) {
          // Allow staying on signin during login flow
          print('Allowing access to signin during login flow');
          return null;
        }
      }

      // Default: allow access to public routes for non-authenticated users
      if (!isAuthenticated && publicRoutes.contains(route)) {
        print('Allowing access to public route for non-authenticated user');
        return null;
      }

      // If we get here and user is not authenticated, redirect to splash
      if (!isAuthenticated) {
        print('Redirecting non-authenticated user to welcome screen');
        return RouteSettings(name: AppRoutes.splash);
      }

      print('Route allowed by default: $route');
      return null; // Allow access

    } catch (e) {
      // If there's any error getting AuthProvider, redirect to welcome screen
      print('Error in middleware: $e - redirecting to welcome screen');
      return RouteSettings(name: AppRoutes.splash);
    }
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    print('Page called: ${page?.name}');
    return super.onPageCalled(page);
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    print('Bindings start');
    return super.onBindingsStart(bindings);
  }
}