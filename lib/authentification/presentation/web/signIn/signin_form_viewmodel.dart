// lib/authentification/presentation/web/signIn/signin_form_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../../../../core/enums/enums.dart';
import '../../../../../core/routes/routes.dart';
import '../../../providers/auth_provider.dart';

class SigninFormWebViewModel with ChangeNotifier {
  final AuthProvider _authProvider;

  bool _isLoading = false;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  SigninFormWebViewModel({required AuthProvider authProvider})
      : _authProvider = authProvider {
    // Listen to auth provider changes
    _authProvider.addListener(_onAuthStateChanged);
  }

  // Getters
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get identifierController => _identifierController;
  TextEditingController get passwordController => _passwordController;
  
  // Auth provider state getters
  AuthState get authState => _authProvider.state;
  String? get errorMessage => _authProvider.errorMessage;
  bool get isAuthenticated => _authProvider.isAuthenticated;

  // Setter for rememberMe
  set rememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  // Listen to auth provider state changes
  void _onAuthStateChanged() {
    final previousLoading = _isLoading;
    _isLoading = _authProvider.state == AuthState.loading;
    
    // Only notify if loading state actually changed
    if (previousLoading != _isLoading) {
      notifyListeners();
    }

    // Handle successful authentication
    if (_authProvider.state == AuthState.success && _authProvider.isAuthenticated) {
      print('Authentication successful, navigating to home...');
      _navigateToHome();
    }
  }

  // IMPROVED: Direct login with password
  Future<void> login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();
    
    print('Starting login process for identifier: $identifier');
    
    try {
      // Clear any previous errors
      _authProvider.clearError();
      
      // Start login process
      await _authProvider.login(
        identifier: identifier,
        password: password,
      );
      
      // Check the final state after login
      if (_authProvider.state == AuthState.success && _authProvider.isAuthenticated && context.mounted) {
        print('Login successful, showing success message...');
        
        if (_rememberMe) {
          await _saveCredentials();
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful! Welcome ${_authProvider.currentUser?.name ?? ''}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to home page with a slight delay to show the message
        Future.delayed(const Duration(milliseconds: 500), () {
          if (Get.currentRoute != AppRoutes.home) {
            print('Navigating to home page...');
            Get.offAllNamed(AppRoutes.home);
          }
        });
        
      } else if (_authProvider.state == AuthState.error && context.mounted) {
        print('Login failed with error: ${_authProvider.errorMessage}');
        _showErrorMessage(context, _authProvider.errorMessage);
      } else if (_authProvider.state == AuthState.loading) {
        print('Login still in progress...');
        // Login is still in progress, wait for state change
      } else {
        print('Unexpected login state: ${_authProvider.state}, authenticated: ${_authProvider.isAuthenticated}');
        if (context.mounted) {
          _showErrorMessage(context, 'Login process completed but authentication failed. Please try again.');
        }
      }
    } catch (e) {
      print('Exception during login: $e');
      if (context.mounted) {
        _showErrorMessage(context, 'Unexpected error during login: ${e.toString()}');
      }
    }
  }

  // NEW: Helper method to navigate to home
  void _navigateToHome() {
    if (Get.currentRoute != AppRoutes.home) {
      print('Navigating to home from auth state change...');
      Get.offAllNamed(AppRoutes.home);
    }
  }

  // Navigate to forgot password page
  void navigateToForgotPassword(BuildContext context) {
    _authProvider.clearError();
    // For now, show a dialog since the route might not be implemented
    _showComingSoonDialog(context, 'Forgot Password');
  }

  // Navigate to sign up page
  void navigateToSignUp(BuildContext context) {
    _authProvider.clearError();
    Get.toNamed(AppRoutes.signupForm);
  }

  // Show error message
  void _showErrorMessage(BuildContext context, String? message) {
    if (message != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // Helper method to show coming soon dialog
  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: const Text('This feature will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Save credentials to secure storage
  Future<void> _saveCredentials() async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'identifier', value: _identifierController.text);
      await storage.write(key: 'remember_me', value: _rememberMe.toString());
      print('Credentials saved successfully');
    } catch (e) {
      print('Error saving credentials: $e');
    }
  }

  // Load saved credentials on initialization
  Future<void> loadSavedCredentials() async {
    try {
      const storage = FlutterSecureStorage();
      final savedIdentifier = await storage.read(key: 'identifier');
      final savedRememberMe = await storage.read(key: 'remember_me');
      
      if (savedIdentifier != null) {
        _identifierController.text = savedIdentifier;
        print('Loaded saved identifier');
      }
      
      if (savedRememberMe != null) {
        _rememberMe = savedRememberMe.toLowerCase() == 'true';
        print('Loaded remember me preference: $_rememberMe');
      }
      
      notifyListeners();
    } catch (e) {
      print('Error loading saved credentials: $e');
    }
  }

  // Validation methods
  String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or phone required';
    }
    
    // Basic email validation
    if (value.contains('@')) {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Invalid email format';
      }
    } else {
      // Basic phone validation (adjust regex based on your requirements)
      if (!RegExp(r'^\+?[\d\s-()]+$').hasMatch(value)) {
        return 'Invalid phone format';
      }
    }
    
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password required';
    }
    
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _authProvider.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}