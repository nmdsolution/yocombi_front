// lib/authentification/presentation/web/completeRegistration/complete_registration_page_web.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../core/enums/enums.dart';
import '../../../../presentation/widgets/yocombi_logo.dart';
import '../../../providers/auth_provider.dart';
import 'complete_registration_web_view_model.dart';

class CompleteRegistrationPageWeb extends StatefulWidget {
  const CompleteRegistrationPageWeb({super.key});

  @override
  State<CompleteRegistrationPageWeb> createState() => _CompleteRegistrationPageWebState();
}

class _CompleteRegistrationPageWebState extends State<CompleteRegistrationPageWeb>
    with TickerProviderStateMixin {
  late CompleteRegistrationWebViewModel _viewModel;
  
  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _formController;
  late AnimationController _buttonController;
  
  // Animations
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _viewModel = CompleteRegistrationWebViewModel(
      authProvider: context.read<AuthProvider>(),
    );
  
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _formController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOut),
    );
    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 200));
    _formController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _buttonController.forward();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _logoController.dispose();
    _formController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2d5a4f),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2d5a4f),
              Color(0xFF1a3d35),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: ChangeNotifierProvider.value(
              value: _viewModel,
              child: Consumer<CompleteRegistrationWebViewModel>(
                builder: (context, viewModel, child) {
                  return Form(
                    key: viewModel.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(viewModel),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 50),
                                _buildTitle(),
                                const SizedBox(height: 40),
                                _buildInputFields(viewModel),
                                _buildCompleteButton(viewModel),
                                _buildAlternativeText(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(CompleteRegistrationWebViewModel viewModel) {
    return AnimatedBuilder(
      animation: _logoAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _logoAnimation.value)),
          child: Opacity(
            opacity: _logoAnimation.value,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: const Text(
                      '←',
                      style: TextStyle(
                        color: Color(0xFFffd700),
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Row(
                  children: [
                    const YoCombiLogo(
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'YoCombi!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFdc3545),
                        fontFamily: 'system-ui',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: const Column(
              children: [
                Text(
                  'Complete Registration',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'system-ui',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  'Please fill in your details to complete your registration',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFa0b4a8),
                    height: 1.4,
                    fontFamily: 'system-ui',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputFields(CompleteRegistrationWebViewModel viewModel) {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: Column(
              children: [
                // Name field
                _buildInputField(
                  controller: viewModel.nameController,
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  validator: viewModel.validateName,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                
                // Password field
                _buildPasswordField(
                  controller: viewModel.passwordController,
                  label: 'Password',
                  hintText: 'Enter your password',
                  validator: viewModel.validatePassword,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                
                // Confirm Password field
                _buildPasswordField(
                  controller: viewModel.confirmPasswordController,
                  label: 'Confirm Password',
                  hintText: 'Confirm your password',
                  validator: viewModel.validatePasswordConfirmation,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.done,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: 'system-ui',
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFffd700),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFFa0b4a8),
          fontSize: 16,
          fontFamily: 'system-ui',
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFFffd700),
          fontSize: 14,
          fontFamily: 'system-ui',
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFa0b4a8),
          fontSize: 16,
          fontFamily: 'system-ui',
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? Function(String?)? validator,
    TextInputAction textInputAction = TextInputAction.done,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: true,
      textInputAction: textInputAction,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: 'system-ui',
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFffd700),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFFa0b4a8),
          fontSize: 16,
          fontFamily: 'system-ui',
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFFffd700),
          fontSize: 14,
          fontFamily: 'system-ui',
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFa0b4a8),
          fontSize: 16,
          fontFamily: 'system-ui',
        ),
      ),
    );
  }

  Widget _buildCompleteButton(CompleteRegistrationWebViewModel viewModel) {
    return AnimatedBuilder(
      animation: _buttonAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _buttonAnimation.value)),
          child: Opacity(
            opacity: _buttonAnimation.value,
            child: Container(
              width: double.infinity,
              height: 55,
              margin: const EdgeInsets.only(top: 30, bottom: 25),
              child: ElevatedButton(
                onPressed: viewModel.isLoading || !viewModel.isFormValid
                  ? null 
                  : () {
                      HapticFeedback.lightImpact();
                      viewModel.completeRegistration(context);
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: viewModel.isFormValid
                      ? const Color(0xFFffd700)
                      : const Color(0xFFffd700).withOpacity(0.5),
                  foregroundColor: const Color(0xFF1a3d35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                  elevation: 0,
                ),
                child: viewModel.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1a3d35)),
                      ),
                    )
                  : const Text(
                      'Complete Registration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'system-ui',
                      ),
                    ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlternativeText() {
    return AnimatedBuilder(
      animation: _buttonAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _buttonAnimation.value)),
          child: Opacity(
            opacity: _buttonAnimation.value,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFFa0b4a8),
                  fontSize: 14,
                  fontFamily: 'system-ui',
                ),
                children: [
                  const TextSpan(text: 'Already have an account? '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _viewModel.navigateToSignIn(context);
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: Color(0xFFffd700),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'system-ui',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}