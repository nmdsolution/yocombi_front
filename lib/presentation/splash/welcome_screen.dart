// lib/presentation/splash/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/routes/routes.dart';
import '../widgets/yocombi_logo.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _titleController;
  late AnimationController _buttonController;
  late AnimationController _textController;

  late Animation<double> _logoAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOut),
    );
    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _titleController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _buttonController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _textController.forward();
  }

  void _onGetStartedPressed() {
    // Add haptic feedback
    HapticFeedback.lightImpact();
    
    // Add button press animation
    _animateButtonPress(() {
      // Navigate to signup form
      Get.toNamed(AppRoutes.signupForm);
    });
  }

  void _onLoginPressed() {
    // Add haptic feedback
    HapticFeedback.lightImpact();
    
    // Navigate to login
    Get.toNamed(AppRoutes.signin);
  }

  void _animateButtonPress(VoidCallback onComplete) {
    // Scale down animation for button press feedback
    _buttonController.reverse().then((_) {
      _buttonController.forward();
      onComplete();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _buttonController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2d5a4f), // Same as HTML design
              Color(0xFF1a3d35), // Same as HTML design
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                // Status bar simulation matching the HTML design
                _buildStatusBar(),
                
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo container with custom animations
                      AnimatedBuilder(
                        animation: _logoAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - _logoAnimation.value)),
                            child: Transform.scale(
                              scale: 0.9 + (0.1 * _logoAnimation.value),
                              child: Opacity(
                                opacity: _logoAnimation.value,
                                child: const YoCombiLogo(
                                  width: 260,
                                  height: 220,
                                 ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // App Title - matching HTML exactly
                      AnimatedBuilder(
                        animation: _titleAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - _titleAnimation.value)),
                            child: Opacity(
                              opacity: _titleAnimation.value,
                              child: const Text(
                                '',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFdc3545), // Same red as HTML
                                  fontFamily: 'system-ui',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 120), // Same spacing as HTML
                      
                      // Get Started Button - matching HTML design
                      AnimatedBuilder(
                        animation: _buttonAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - _buttonAnimation.value)),
                            child: Transform.scale(
                              scale: _buttonAnimation.value,
                              child: Opacity(
                                opacity: _buttonAnimation.value,
                                child: _buildGetStartedButton(),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 25), // Same spacing as HTML
                      
                      // Login text - matching HTML exactly
                      AnimatedBuilder(
                        animation: _textAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - _textAnimation.value)),
                            child: Opacity(
                              opacity: _textAnimation.value,
                              child: _buildLoginText(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              // Signal bars - matching HTML design
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(4, (index) {
                  return Container(
                    width: 4,
                    height: (6 + index * 2).toDouble(),
                    margin: const EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 5),
              // WiFi icon - custom design to match HTML
              CustomPaint(
                size: const Size(18, 18),
                painter: WifiIconPainter(),
              ),
              const SizedBox(width: 5),
              // Battery icon - custom design to match HTML
              CustomPaint(
                size: const Size(27, 13),
                painter: BatteryIconPainter(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return Container(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _onGetStartedPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFffd700), // Exact yellow from HTML
          foregroundColor: const Color(0xFF1a3d35), // Exact dark green from HTML
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27), // Exact border radius from HTML
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ).copyWith(
          overlayColor: WidgetStateProperty.all(
            const Color(0xFFffed4a).withOpacity(0.1), // Hover effect like HTML
          ),
        ),
        child: const Text(
          'Get Started',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return GestureDetector(
      onTap: _onLoginPressed,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Color(0xFFffd700), // Same yellow as HTML
            fontSize: 16,
          ),
          children: [
            const TextSpan(text: 'Already have an account? '),
            TextSpan(
              text: 'Log in',
              style: TextStyle(
                color: const Color(0xFFffd700),
                fontSize: 16,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFFffd700),
                decorationThickness: 1.5,
              ),
              // Add touch feedback for the link
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Custom painter for WiFi icon to match HTML design
class WifiIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw WiFi arc
    path.addArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      -2.356, // -135 degrees
      1.571,  // 90 degrees
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for Battery icon to match HTML design
class BatteryIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw battery outline
    final batteryRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width - 3, size.height),
      const Radius.circular(3),
    );
    canvas.drawRRect(batteryRect, paint);

    // Draw battery tip
    final tipRect = Rect.fromLTWH(
      size.width - 3,
      size.height * 0.3,
      2,
      size.height * 0.4,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(tipRect, const Radius.circular(1)),
      fillPaint,
    );

    // Draw battery fill
    final fillRect = Rect.fromLTWH(
      1,
      1,
      (size.width - 5) * 1.0, // 100% charged
      size.height - 2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(fillRect, const Radius.circular(1)),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}