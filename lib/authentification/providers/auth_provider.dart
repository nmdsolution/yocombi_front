// lib/authentification/providers/auth_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/enums/enums.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/token_refresh_service.dart';
import '../data/repositories/auth_repository.dart';
import '../domain/entities/user.dart';
import '../domain/entities/auth_entity_request.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/send_otp_usecase.dart';
import '../domain/usecases/verify_otp_usecase.dart';
import '../domain/usecases/complete_registration_usecase.dart';
import '../domain/usecases/refresh_token_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUsecase loginUsecase;
  final SendOtpUsecase sendOtpUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final CompleteRegistrationUsecase completeRegistrationUsecase;
  final AuthRepository authRepository;
  final RefreshTokenUseCase refreshTokenUseCase;
  final TokenRefreshService tokenRefreshService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthProvider({
    required this.loginUsecase,
    required this.sendOtpUsecase,
    required this.verifyOtpUsecase,
    required this.completeRegistrationUsecase,
    required this.authRepository,
    required this.refreshTokenUseCase,
    required this.tokenRefreshService,
  }) {
    initializeAuth();
  }

  // Private properties
  AuthState _state = AuthState.initial;
  User? _currentUser;
  String? _errorMessage;
  bool _isAuthenticated = false;
  String? _authToken;
  String? _otpMethod; // "email" or "phone"
  String? _currentIdentifier; // Store the identifier for the current auth flow
  String? _currentType; // Store current flow type ("login" or "register")
  String? _sessionToken; // Store session token for registration completion

  // Getters
  AuthState get state => _state;
  User? get currentUser => _currentUser;
  User? get user => _currentUser; // For backward compatibility
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  String? get authToken => _authToken;
  String? get otpMethod => _otpMethod;
  String? get currentIdentifier => _currentIdentifier;
  String? get currentType => _currentType;
  String? get sessionToken => _sessionToken;

  // Private method to update state and notify listeners
  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  // Initialize authentication on app start
  Future<void> initializeAuth() async {
    try {
      // Check for stored token
      final storedToken = await _secureStorage.read(key: AppConstants.tokenKey);
      
      if (storedToken != null) {
        _authToken = storedToken;
        _isAuthenticated = await authRepository.isAuthenticated();
        
        if (_isAuthenticated) {
          tokenRefreshService.startTokenRefresh();
          final result = await authRepository.getCurrentUser();
          result.fold(
            (failure) {
              _isAuthenticated = false;
              _clearStoredAuth();
              _setState(AuthState.initial);
            },
            (user) {
              _currentUser = user;
              _setState(AuthState.success);
            },
          );
        } else {
          _clearStoredAuth();
          _setState(AuthState.initial);
        }
      } else {
        _isAuthenticated = false;
        _setState(AuthState.initial);
      }
    } catch (e) {
      print('Error initializing auth: $e');
      _isAuthenticated = false;
      _clearStoredAuth();
      _setState(AuthState.initial);
    }
    notifyListeners();
  }

  // Direct login with password (FIXED VERSION)
  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    _setState(AuthState.loading);
    _errorMessage = null;
    
    final request = AuthEntityRequest.directLogin(
      identifier: identifier,
      password: password,
    );
    
    final result = await loginUsecase(request);
    
    result.fold(
      (failure) {
        _errorMessage = failure.userFriendlyMessage ?? failure.message;
        _setState(AuthState.error); // FIXED: Set error state for failures
      },
      (response) async {
        // Handle the login response
        await _handleLoginSuccess(response);
      },
    );
  }

  // FIXED: Handle successful login after OTP verification or direct login
  Future<void> _handleLoginSuccess(Map<String, dynamic> response) async {
    try {
      print('Processing login success with response: $response');
      
      User? user;
      String token = '';
      
      // Extract user and token from response
      if (response.containsKey('user')) {
        user = User.fromJson(response['user']);
        print('User extracted: ${user.name}');
      }
      
      if (response.containsKey('token')) {
        token = response['token'];
        print('Token extracted: ${token.substring(0, 20)}...');
      } else if (response.containsKey('access_token')) {
        token = response['access_token'];
        print('Access token extracted: ${token.substring(0, 20)}...');
      }

      if (user != null && token.isNotEmpty) {
        // Store authentication data
        await _storeAuthData(token, user);
        
        // Start token refresh service
        tokenRefreshService.startTokenRefresh();
        
        // Clear auth flow
        _clearAuthFlow();
        
        // Set success state
        _setState(AuthState.success);
        
        print('Login success handled successfully. User authenticated: $_isAuthenticated');
        
      } else {
        print('Warning: Missing user or token in login response');
        
        // If we have user but no token, still try to proceed
        if (user != null) {
          _currentUser = user;
          _isAuthenticated = true;
          _clearAuthFlow();
          _setState(AuthState.success);
          print('Login completed without token storage');
        } else {
          // Try to fetch current user if we have a token stored
          await _fetchCurrentUserAfterLogin();
        }
      }
    } catch (e) {
      print('Error handling login success: $e');
      _errorMessage = 'Failed to process login response: $e';
      _setState(AuthState.error); // FIXED: Set error state for exceptions
    }
  }

  // Store authentication data securely (IMPROVED)
  Future<void> _storeAuthData(String token, User user) async {
    try {
      print('Storing auth data for user: ${user.name}');
      
      // Store token
      await _secureStorage.write(key: AppConstants.tokenKey, value: token);
      
      // Store user data as JSON string
      final userJsonString = jsonEncode(user.toJson());
      await _secureStorage.write(key: AppConstants.userDataKey, value: userJsonString);
      
      // Update instance variables
      _authToken = token;
      _currentUser = user;
      _isAuthenticated = true;
      
      print('Auth data stored successfully');
    } catch (e) {
      print('Error storing auth data: $e');
      throw Exception('Failed to store authentication data: $e');
    }
  }

  // Clear stored authentication data
  Future<void> _clearStoredAuth() async {
    try {
      await _secureStorage.delete(key: AppConstants.tokenKey);
      await _secureStorage.delete(key: AppConstants.userDataKey);
      await _secureStorage.delete(key: AppConstants.tokenTypeKey);
      await _secureStorage.delete(key: AppConstants.expiresInKey);
      
      _authToken = null;
      _currentUser = null;
      _isAuthenticated = false;
    } catch (e) {
      print('Error clearing stored auth: $e');
    }
  }

  // Send OTP for Login
  Future<void> sendLoginOtp(String identifier) async {
    _setState(AuthState.loading);
    _errorMessage = null;
    
    final request = AuthEntityRequest.sendLoginOtp(identifier: identifier);
    
    final result = await sendOtpUsecase(request);
    
    result.fold(
      (failure) {
        _errorMessage = failure.userFriendlyMessage ?? failure.message;
        _setState(AuthState.error); // FIXED: Set error state for failures
      },
      (response) {
        _currentIdentifier = identifier;
        _currentType = 'login';
        _otpMethod = response['method']; // API returns "email" or "phone"
        _setState(AuthState.otpSent);
      },
    );
  }

  // Send OTP for Register
  Future<void> sendRegisterOtp(String identifier) async {
    _setState(AuthState.loading);
    _errorMessage = null;
    
    final request = AuthEntityRequest.sendRegisterOtp(identifier: identifier);
    
    final result = await sendOtpUsecase(request);
    
    result.fold(
      (failure) {
        _errorMessage = failure.userFriendlyMessage ?? failure.message;
        _setState(AuthState.error); // FIXED: Set error state for failures
      },
      (response) {
        _currentIdentifier = identifier;
        _currentType = 'register';
        _otpMethod = response['method']; // API returns "email" or "phone"
        _setState(AuthState.otpSent);
      },
    );
  }

  // Verify OTP (for both login and register)
  Future<void> verifyOtp(String code) async {
    if (_currentIdentifier == null || _currentType == null) {
      _errorMessage = 'Invalid authentication flow. Please start over.';
      _setState(AuthState.error); // FIXED: Set error state for invalid flow
      return;
    }

    _setState(AuthState.loading);
    _errorMessage = null;
    
    final request = AuthEntityRequest.verifyOtp(
      identifier: _currentIdentifier!,
      code: code,
      type: _currentType!,
    );
    
    final result = await verifyOtpUsecase(request);
    
    result.fold(
      (failure) {
        _errorMessage = failure.userFriendlyMessage ?? failure.message;
        _setState(AuthState.error); // FIXED: Set error state for failures
      },
      (response) async {
        if (_currentType == 'login') {
          // For login, we should get user data and tokens
          await _handleLoginSuccess(response);
        } else {
          // For register, store session token and go to registration completion
          _sessionToken = response['session_token'] as String?;
          _setState(AuthState.otpVerified);
        }
      },
    );
  }

  // Complete Registration (after OTP verification for register flow)
  Future<void> completeRegistration({
    required String name,
    required String password,
    required String passwordConfirmation,
    String userType = 'individual',
    String accountType = 'client',
  }) async {
    if (_currentIdentifier == null || _sessionToken == null) {
      _errorMessage = 'Invalid registration flow. Please start over.';
      _setState(AuthState.error); // FIXED: Set error state for invalid flow
      return;
    }

    _setState(AuthState.loading);
    _errorMessage = null;
    
    final request = AuthEntityRequest.completeRegistration(
      identifier: _currentIdentifier!,
      name: name,
      password: password,
      passwordConfirmation: passwordConfirmation,
      sessionToken: _sessionToken!,
      userType: userType,
      accountType: accountType,
    );
    
    final result = await completeRegistrationUsecase(request);
    
    result.fold(
      (failure) {
        _errorMessage = failure.userFriendlyMessage ?? failure.message;
        _setState(AuthState.error); // FIXED: Set error state for failures
      },
      (user) {
        _handleRegistrationSuccess(user);
      },
    );
  }

  // Handle successful registration completion
  Future<void> _handleRegistrationSuccess(User user) async {
    try {
      // Store user data (token should already be stored by repository)
      _currentUser = user;
      _isAuthenticated = true;

      // Start token refresh service
      tokenRefreshService.startTokenRefresh();
      
      // Update state
      _setState(AuthState.success);
      _clearAuthFlow();
      
      print('Registration completed successfully for user: ${user.name}');
    } catch (e) {
      print('Error handling registration success: $e');
      _errorMessage = 'Registration completed but failed to authenticate. Please try logging in.';
      _setState(AuthState.error); // FIXED: Set error state for exceptions
    }
  }

  // Fetch current user after successful login (IMPROVED)
  Future<void> _fetchCurrentUserAfterLogin() async {
    try {
      print('Fetching current user after login...');
      
      final result = await authRepository.getCurrentUser();
      result.fold(
        (failure) {
          print('Failed to fetch current user: ${failure.message}');
          _errorMessage = 'Login successful but failed to load user data';
          _setState(AuthState.error); // FIXED: Set error state for failures
        },
        (user) async {
          print('Current user fetched successfully: ${user?.name}');
          
          _currentUser = user;
          _isAuthenticated = true;
          
          // Store user data
          try {
            if (user != null) {
              final userJsonString = jsonEncode(user.toJson());
              await _secureStorage.write(key: AppConstants.userDataKey, value: userJsonString);
            }
          } catch (e) {
            print('Error storing user data: $e');
          }
          
          tokenRefreshService.startTokenRefresh();
          _setState(AuthState.success);
          _clearAuthFlow();
        },
      );
    } catch (e) {
      print('Error fetching current user: $e');
      _errorMessage = 'Failed to load user data';
      _setState(AuthState.error); // FIXED: Set error state for exceptions
    }
  }

  // Clear current authentication flow data
  void _clearAuthFlow() {
    _currentIdentifier = null;
    _currentType = null;
    _otpMethod = null;
    _sessionToken = null;
  }

  // Manual setters for edge cases
  void setCurrentUser(User user) {
    _currentUser = user;
    _isAuthenticated = true;
    _errorMessage = null;
    _setState(AuthState.success);
  }

  void setError(String error) {
    _errorMessage = error;
    _setState(AuthState.error); // FIXED: Set error state for manual errors
  }

  void setLoading() {
    _errorMessage = null;
    _setState(AuthState.loading);
  }

  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _setState(_isAuthenticated ? AuthState.success : AuthState.initial);
    }
  }

  // Reset authentication flow (useful when user wants to start over)
  void resetAuthFlow() {
    _clearAuthFlow();
    _errorMessage = null;
    _setState(_isAuthenticated ? AuthState.success : AuthState.initial);
  }

  // Logout method
  Future<void> logout() async {
    try {
      // Stop token refresh
      tokenRefreshService.stopTokenRefresh();

      // Clear stored authentication data
      await _clearStoredAuth();
      
      // Clear auth flow data
      _clearAuthFlow();
      _errorMessage = null;

      // Clear from repository/storage
      await authRepository.logout();

      _setState(AuthState.initial);
    } catch (e) {
      print('Error during logout: $e');
      // Even if logout fails, clear local state
      await _clearStoredAuth();
      _clearAuthFlow();
      _errorMessage = null;
      _setState(AuthState.initial);
    }
  }

  // Set auth token (if needed manually)
  void setAuthToken(String token) {
    _authToken = token;
    _secureStorage.write(key: AppConstants.tokenKey, value: token);
    notifyListeners();
  }

  // Refresh user data
  Future<void> refreshUserData() async {
    if (!_isAuthenticated) return;

    try {
      final result = await authRepository.getCurrentUser();
      result.fold(
        (failure) {
          // If refresh fails, consider logging out
          logout();
        },
        (user) {
          _currentUser = user;
          // Update stored user data
          if (user != null) {
            final userJsonString = jsonEncode(user.toJson());
            _secureStorage.write(key: AppConstants.userDataKey, value: userJsonString);
          }
          notifyListeners();
        },
      );
    } catch (e) {
      // If refresh fails, consider logging out
      logout();
    }
  }

  // Check if current identifier is email or phone
  bool get isCurrentIdentifierEmail => 
      _currentIdentifier != null && _currentIdentifier!.contains('@');
      
  bool get isCurrentIdentifierPhone => 
      _currentIdentifier != null && !_currentIdentifier!.contains('@');

  // Helper method to check if registration flow is valid
  bool get isValidRegistrationFlow => 
      _currentIdentifier != null && 
      _currentType == 'register' &&
      (_state == AuthState.otpVerified || _state == AuthState.otpSent);
}
