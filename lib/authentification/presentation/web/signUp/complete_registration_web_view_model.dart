// lib/authentification/presentation/web/completeRegistration/complete_registration_web_view_model.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/enums/enums.dart';
import '../../../../../core/routes/routes.dart';
import '../../../providers/auth_provider.dart';

class CompleteRegistrationWebViewModel with ChangeNotifier {
  final AuthProvider _authProvider;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  CompleteRegistrationWebViewModel({required AuthProvider authProvider})
      : _authProvider = authProvider {
    // Listen to auth provider changes
    _authProvider.addListener(_onAuthStateChanged);
    
    // Initialize with current identifier if available
    if (_authProvider.currentIdentifier != null) {
      print('CompleteRegistration initialized with identifier: ${_authProvider.currentIdentifier}');
    }

    // Check if session is valid on initialization
    _checkSessionValidity();
  }

  // Getters
  bool get isLoading => _isLoading;
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get nameController => _nameController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController => _confirmPasswordController;
  
  // Auth provider state getters
  AuthState get authState => _authProvider.state;
  String? get errorMessage => _authProvider.errorMessage;
  bool get isAuthenticated => _authProvider.isAuthenticated;
  
  // Check if form is valid
  bool get isFormValid => 
    _nameController.text.trim().isNotEmpty &&
    _passwordController.text.trim().isNotEmpty &&
    _confirmPasswordController.text.trim().isNotEmpty &&
    _passwordController.text == _confirmPasswordController.text;

  // Listen to auth provider state changes
  void _onAuthStateChanged() {
    final previousIsAuthenticated = _isLoading ? false : isAuthenticated;
    _isLoading = _authProvider.state == AuthState.loading;
    
    // If user just became authenticated, navigate to home
    if (!previousIsAuthenticated && _authProvider.isAuthenticated && _authProvider.state == AuthState.success) {
      // Use a small delay to ensure the UI is ready for navigation
      Future.delayed(const Duration(milliseconds: 500), () {
        if (Get.currentRoute != AppRoutes.home) {
          print('Registration completed successfully, navigating to home');
          Get.offAllNamed(AppRoutes.home);
        }
      });
    }
    
    notifyListeners();
  }

  // Check session validity when view model is created
  void _checkSessionValidity() {
    if (!isSessionValid) {
      print('Invalid registration session detected, will redirect to signup');
      Future.delayed(const Duration(milliseconds: 100), () {
        _showErrorMessage(
          Get.context!,
          'Registration session expired. Please start over.',
        );
        _navigateToSignUp();
      });
    }
  }

  // Complete registration with user details
  Future<void> completeRegistration(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (!isFormValid) {
      _showErrorMessage(context, 'Please fill in all required fields correctly');
      return;
    }

    // Check password confirmation
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorMessage(context, 'Passwords do not match');
      return;
    }

    // Check if we have a verified identifier from the auth flow
    if (_authProvider.currentIdentifier == null || _authProvider.sessionToken == null) {
      _showErrorMessage(context, 'Registration session expired. Please start over.');
      _navigateToSignUp();
      return;
    }

    // Double check session validity
    if (!isSessionValid) {
      _showErrorMessage(context, 'Invalid registration session. Please start over.');
      _navigateToSignUp();
      return;
    }

    try {
      print('Starting registration completion with:');
      print('- Name: ${_nameController.text.trim()}');
      print('- Identifier: ${_authProvider.currentIdentifier}');
      print('- Session Token: ${_authProvider.sessionToken}');
      
      await _authProvider.completeRegistration(
        name: _nameController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );
      
      // The navigation is handled in _onAuthStateChanged when state becomes success
      if (_authProvider.state == AuthState.success) {
        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Welcome ${_authProvider.currentUser?.name ?? _nameController.text.trim()}! Your account has been created successfully.',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else if (_authProvider.state == AuthState.error) {
        if (context.mounted) {
          _showErrorMessage(context, _authProvider.errorMessage);
        }
      }
    } catch (e) {
      print('Error completing registration: $e');
      if (context.mounted) {
        _showErrorMessage(context, 'Unexpected error: ${e.toString()}');
      }
    }
  }

  // Navigate to sign in page
  void navigateToSignIn(BuildContext context) {
    _authProvider.clearError();
    Get.offAllNamed(AppRoutes.signin);
  }

  // Navigate to sign up page (in case session expired)
  void _navigateToSignUp() {
    _authProvider.resetAuthFlow();
    Get.offAllNamed(AppRoutes.signupForm);
  }

  // Show error message
  void _showErrorMessage(BuildContext context, String? message) {
    if (message != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  // Reset form
  void resetForm() {
    _nameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    notifyListeners();
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-ZÀ-ÿ\s\-'\.]+$").hasMatch(value.trim())) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  String? validatePasswordConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  // Check if current session is valid for registration completion
  bool get isSessionValid => 
    _authProvider.currentIdentifier != null && 
    _authProvider.currentType == 'register' &&
    _authProvider.sessionToken != null &&
    (_authProvider.state == AuthState.otpVerified || 
     _authProvider.state == AuthState.otpSent ||
     _authProvider.state == AuthState.loading ||
     _authProvider.state == AuthState.success);

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _authProvider.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}