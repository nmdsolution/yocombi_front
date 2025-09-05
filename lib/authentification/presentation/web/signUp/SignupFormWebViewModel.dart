// lib/authentification/presentation/web/signUp/SignupFormWebViewModel.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../../../../core/enums/enums.dart';
import '../../../../../core/routes/routes.dart';
import '../../../providers/auth_provider.dart';

class SignupFormWebViewModel with ChangeNotifier {
  final AuthProvider _authProvider;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _otpController = TextEditingController();
  
  // Registration flow state
  bool _isOtpSent = false;

  SignupFormWebViewModel({required AuthProvider authProvider})
      : _authProvider = authProvider {
    // Listen to auth provider changes
    _authProvider.addListener(_onAuthStateChanged);
  }

  // Getters
  bool get isLoading => _isLoading;
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get identifierController => _identifierController;
  TextEditingController get otpController => _otpController;
  
  // Auth provider state getters
  AuthState get authState => _authProvider.state;
  String? get errorMessage => _authProvider.errorMessage;
  String? get otpMethod => _authProvider.otpMethod;
  bool get isOtpSent => _isOtpSent || _authProvider.state == AuthState.otpSent;
  bool get isAuthenticated => _authProvider.isAuthenticated;

  // Listen to auth provider state changes
  void _onAuthStateChanged() {
    _isLoading = _authProvider.state == AuthState.loading;
    
    // Update local state based on auth provider state
    if (_authProvider.state == AuthState.otpSent) {
      _isOtpSent = true;
    }
    
    notifyListeners();
  }

  // Send OTP for registration
  Future<void> sendRegistrationOtp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final identifier = _identifierController.text.trim();
    
    try {
      await _authProvider.sendRegisterOtp(identifier);
      
      if (_authProvider.state == AuthState.otpSent && context.mounted) {
        _isOtpSent = true;
        final method = _authProvider.otpMethod ?? 'your device';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification code sent to your $method'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (_authProvider.state == AuthState.error && context.mounted) {
        _showErrorMessage(context, _authProvider.errorMessage);
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, 'Unexpected error: ${e.toString()}');
      }
    }
  }

  // Verify OTP for registration
  Future<void> verifyRegistrationOtp(BuildContext context) async {
    if (_otpController.text.trim().isEmpty) {
      _showErrorMessage(context, 'Please enter the OTP code');
      return;
    }

    try {
      await _authProvider.verifyOtp(_otpController.text.trim());
      
      if (_authProvider.state == AuthState.otpVerified && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Code verified successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to complete registration page
        Get.toNamed(AppRoutes.completeRegistration);
        
      } else if (_authProvider.state == AuthState.error && context.mounted) {
        _showErrorMessage(context, _authProvider.errorMessage);
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, 'Unexpected error: ${e.toString()}');
      }
    }
  }

  // Resend OTP
  Future<void> resendOtp(BuildContext context) async {
    if (_identifierController.text.trim().isEmpty) {
      _showErrorMessage(context, 'Please enter your email or phone');
      return;
    }

    await sendRegistrationOtp(context);
  }

  // Reset form for new registration attempt
  void resetForm() {
    _otpController.clear();
    _isOtpSent = false;
    _authProvider.resetAuthFlow();
    notifyListeners();
  }

  // Navigate to sign in page
  void navigateToSignIn(BuildContext context) {
    _authProvider.clearError();
    Get.toNamed(AppRoutes.signin);
  }

  // Show error message
  void _showErrorMessage(BuildContext context, String? message) {
    if (message != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
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
      // Basic phone validation
      if (!RegExp(r'^\+?[\d\s-()]+$').hasMatch(value)) {
        return 'Invalid phone format';
      }
    }
    
    return null;
  }

  String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP code required';
    }
    
    if (value.trim().length < 4) {
      return 'OTP code too short';
    }
    
    return null;
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _otpController.dispose();
    _authProvider.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}