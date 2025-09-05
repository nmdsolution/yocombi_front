// "type": "register"
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../core/enums/enums.dart';
import '../../../../presentation/widgets/yocombi_logo.dart';
import '../../../providers/auth_provider.dart';

import 'SignupFormWebViewModel.dart';

class SignupFormPageWeb extends StatefulWidget {
  const SignupFormPageWeb({super.key});

  @override
  State<SignupFormPageWeb> createState() => _SignupFormPageWebState();
}

class _SignupFormPageWebState extends State<SignupFormPageWeb>
    with TickerProviderStateMixin {
  late SignupFormWebViewModel _viewModel;
  
  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _formController;
  late AnimationController _buttonController;
  
  // Animations
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _buttonAnimation;

  bool _isPhoneSelected = true;

  @override
  void initState() {
    super.initState();
    _viewModel = SignupFormWebViewModel(
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
              child: Consumer<SignupFormWebViewModel>(
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
                                // Show different content based on auth state
                                if (!viewModel.isOtpSent) ...[
                                  _buildTitle(),
                                  _buildVerificationIcons(),
                                  _buildVerificationOptions(viewModel),
                                  _buildSendButton(viewModel),
                                ] else ...[
                                  _buildOtpTitle(viewModel),
                                  _buildOtpInput(viewModel),
                                  _buildVerifyButton(viewModel),
                                  _buildResendButton(viewModel),
                                ],
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

  Widget _buildHeader(SignupFormWebViewModel viewModel) {
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
                  'Create Account',
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
                  'We\'ll send you a verification code to confirm your identity and create your account securely',
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

  Widget _buildOtpTitle(SignupFormWebViewModel viewModel) {
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
                  'Enter Verification Code',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'system-ui',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  'We\'ve sent a code to your ${viewModel.otpMethod ?? 'device'}',
                  style: const TextStyle(
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

  Widget _buildVerificationIcons() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value * 0.7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: const Size(30, 30),
                  painter: ShieldIconPainter(),
                ),
                const SizedBox(width: 15),
                CustomPaint(
                  size: const Size(30, 30),
                  painter: EmailIconPainter(),
                ),
                const SizedBox(width: 15),
                CustomPaint(
                  size: const Size(30, 30),
                  painter: PhoneIconPainter(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerificationOptions(SignupFormWebViewModel viewModel) {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Option buttons
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.only(bottom: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPhoneSelected = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isPhoneSelected 
                                  ? const Color(0xFFffd700) 
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Phone',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: _isPhoneSelected 
                                    ? FontWeight.w600 
                                    : FontWeight.w500,
                                color: _isPhoneSelected 
                                    ? const Color(0xFF1a3d35) 
                                    : const Color(0xFFa0b4a8),
                                fontFamily: 'system-ui',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPhoneSelected = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isPhoneSelected 
                                  ? const Color(0xFFffd700) 
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Email',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: !_isPhoneSelected 
                                    ? FontWeight.w600 
                                    : FontWeight.w500,
                                color: !_isPhoneSelected 
                                    ? const Color(0xFF1a3d35) 
                                    : const Color(0xFFa0b4a8),
                                fontFamily: 'system-ui',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Input field
                if (_isPhoneSelected) _buildPhoneInput(viewModel) else _buildEmailInput(viewModel),
                
                const SizedBox(height: 8),
                
                // Helper text
                Text(
                  _isPhoneSelected 
                      ? 'We\'ll send a 6-digit code to verify your phone number'
                      : 'We\'ll send a verification link to your email address',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFa0b4a8),
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

  Widget _buildPhoneInput(SignupFormWebViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          TextFormField(
            controller: viewModel.identifierController,
            validator: viewModel.validateIdentifier,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'system-ui',
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(60, 18, 20, 18),
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
              hintText: 'Phone number',
              hintStyle: const TextStyle(
                color: Color(0xFFa0b4a8),
                fontSize: 16,
                fontFamily: 'system-ui',
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                '+237',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'system-ui',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailInput(SignupFormWebViewModel viewModel) {
    return TextFormField(
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
        hintText: 'Email address',
        hintStyle: const TextStyle(
          color: Color(0xFFa0b4a8),
          fontSize: 16,
          fontFamily: 'system-ui',
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildOtpInput(SignupFormWebViewModel viewModel) {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: TextFormField(
              controller: viewModel.otpController,
              validator: viewModel.validateOtp,
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
                hintText: 'Enter 6-digit code',
                hintStyle: const TextStyle(
                  color: Color(0xFFa0b4a8),
                  fontSize: 16,
                  fontFamily: 'system-ui',
                ),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSendButton(SignupFormWebViewModel viewModel) {
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
                      viewModel.sendRegistrationOtp(context);
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: viewModel.identifierController.text.isNotEmpty 
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
                      'Send Verification Code',
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

  Widget _buildVerifyButton(SignupFormWebViewModel viewModel) {
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
                      viewModel.verifyRegistrationOtp(context);
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: viewModel.otpController.text.isNotEmpty 
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
                      'Verify Code',
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

  Widget _buildResendButton(SignupFormWebViewModel viewModel) {
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
                onPressed: viewModel.isLoading 
                  ? null 
                  : () {
                      HapticFeedback.lightImpact();
                      viewModel.resendOtp(context);
                    },
                child: const Text(
                  'Resend Code',
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

// In the _buildAlternativeText() method, update it to:
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
                      'Sign In',
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

// Custom painters for icons (keeping the same as original)
class ShieldIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFa0b4a8)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.04167);
    path.lineTo(size.width * 0.125, size.height * 0.20833);
    path.lineTo(size.width * 0.125, size.height * 0.45833);
    path.cubicTo(size.width * 0.125, size.height * 0.6875, size.width * 0.285, size.height * 0.9058, size.width * 0.5, size.height * 0.9583);
    path.cubicTo(size.width * 0.715, size.height * 0.9058, size.width * 0.875, size.height * 0.6875, size.width * 0.875, size.height * 0.45833);
    path.lineTo(size.width * 0.875, size.height * 0.20833);
    path.close();

    canvas.drawPath(path, path as Paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EmailIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFa0b4a8)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.83333, size.height * 0.33333);
    path.lineTo(size.width * 0.5, size.height * 0.54167);
    path.lineTo(size.width * 0.16667, size.height * 0.33333);
    path.lineTo(size.width * 0.16667, size.height * 0.25);
    path.lineTo(size.width * 0.5, size.height * 0.45833);
    path.lineTo(size.width * 0.83333, size.height * 0.25);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PhoneIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFa0b4a8)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.275, size.height * 0.45);
    path.cubicTo(size.width * 0.336, size.height * 0.568, size.width * 0.432, size.height * 0.664, size.width * 0.55, size.height * 0.725);
    path.lineTo(size.width * 0.642, size.height * 0.633);
    path.cubicTo(size.width * 0.671, size.height * 0.604, size.width * 0.712, size.height * 0.592, size.width * 0.75, size.height * 0.6);
    path.lineTo(size.width * 0.83333, size.height * 0.645);
    path.lineTo(size.width * 0.83333, size.height * 0.83333);
    path.cubicTo(size.width * 0.83333, size.height * 0.875, size.width * 0.791, size.height * 0.9167, size.width * 0.75, size.height * 0.9167);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}