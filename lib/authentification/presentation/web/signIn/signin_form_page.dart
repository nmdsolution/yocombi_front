// lib/authentification/presentation/web/signIn/signin_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../core/enums/enums.dart';
import '../../../../presentation/widgets/yocombi_logo.dart';
import '../../../providers/auth_provider.dart';
import 'signin_form_viewmodel.dart';

class SigninFormPageWeb extends StatefulWidget {
  const SigninFormPageWeb({super.key});

  @override
  State<SigninFormPageWeb> createState() => _SigninFormPageWebState();
}

class _SigninFormPageWebState extends State<SigninFormPageWeb>
    with TickerProviderStateMixin {
  late SigninFormWebViewModel _viewModel;
  
  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _formController;
  late AnimationController _buttonController;
  
  // Animations
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _buttonAnimation;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _viewModel = SigninFormWebViewModel(
      authProvider: context.read<AuthProvider>(),
    );
    _viewModel.loadSavedCredentials();
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
              child: Consumer<SigninFormWebViewModel>(
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
                                _buildIdentifierInput(viewModel),
                                _buildPasswordInput(viewModel),
                                _buildRememberMeCheckbox(viewModel),
                                _buildLoginButton(viewModel),
                                _buildForgotPasswordLink(viewModel),
                                _buildAlternativeText(viewModel),
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

  Widget _buildHeader(SigninFormWebViewModel viewModel) {
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
            child: Column(
              children: [
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'system-ui',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Welcome back! Please sign in to your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFa0b4a8),
                    height: 1.4,
                    fontFamily: 'system-ui',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIdentifierInput(SigninFormWebViewModel viewModel) {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Email or Phone',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'system-ui',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: viewModel.identifierController,
                  validator: viewModel.validateIdentifier,
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
                    hintText: 'Enter your email or phone number',
                    hintStyle: const TextStyle(
                      color: Color(0xFFa0b4a8),
                      fontSize: 16,
                      fontFamily: 'system-ui',
                    ),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Color(0xFFa0b4a8),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordInput(SigninFormWebViewModel viewModel) {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'system-ui',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: viewModel.passwordController,
                  validator: viewModel.validatePassword,
                  obscureText: !_isPasswordVisible,
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
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(
                      color: Color(0xFFa0b4a8),
                      fontSize: 16,
                      fontFamily: 'system-ui',
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFFa0b4a8),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFFa0b4a8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRememberMeCheckbox(SigninFormWebViewModel viewModel) {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: Row(
              children: [
                Checkbox(
                  value: viewModel.rememberMe,
                  onChanged: (value) {
                    viewModel.rememberMe = value ?? false;
                  },
                  activeColor: const Color(0xFFffd700),
                  checkColor: const Color(0xFF1a3d35),
                ),
                const Text(
                  'Remember me',
                  style: TextStyle(
                    color: Color(0xFFa0b4a8),
                    fontSize: 14,
                    fontFamily: 'system-ui',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton(SigninFormWebViewModel viewModel) {
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
                onPressed: viewModel.isLoading 
                  ? null 
                  : () {
                      HapticFeedback.lightImpact();
                      viewModel.login(context);
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFffd700),
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
                      'Sign In',
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

  Widget _buildForgotPasswordLink(SigninFormWebViewModel viewModel) {
    return AnimatedBuilder(
      animation: _buttonAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - _buttonAnimation.value)),
          child: Opacity(
            opacity: _buttonAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  viewModel.navigateToForgotPassword(context);
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xFFffd700),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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

  Widget _buildAlternativeText(SigninFormWebViewModel viewModel) {
    return AnimatedBuilder(
      animation: _buttonAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _buttonAnimation.value)),
          child: Opacity(
            opacity: _buttonAnimation.value,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                viewModel.navigateToSignUp(context);
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    color: Color(0xFFa0b4a8),
                    fontSize: 14,
                    fontFamily: 'system-ui',
                  ),
                  children: [
                    TextSpan(text: 'Don\'t have an account? '),
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        color: Color(0xFFffd700),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}