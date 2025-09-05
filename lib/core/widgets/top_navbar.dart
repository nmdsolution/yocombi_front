// lib/core/widgets/page_header.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../authentification/providers/auth_provider.dart';
import '../routes/routes.dart';
import '../theme/app_theme.dart';

class PageHeader extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showUserProfile;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? backButtonColor;

  const PageHeader({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.showUserProfile = true,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    this.backButtonColor,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> with TickerProviderStateMixin {
  bool _isDropdownOpen = false;
  final LayerLink _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  late AnimationController _backButtonController;
  late AnimationController _profileController;

  @override
  void initState() {
    super.initState();
    _backButtonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _profileController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    if (_isDropdownOpen) {
      _closeDropdown();
    }
    _backButtonController.dispose();
    _profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              // Back Button
              if (widget.showBackButton) ...[
                _buildBackButton(),
                const SizedBox(width: 15),
              ],
              
              // Page Title (Centered)
              Expanded(
                child: Text(
                  widget.title,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: widget.titleColor ?? AppTheme.primaryText,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // User Profile Section
              if (widget.showUserProfile) ...[
                const SizedBox(width: 15),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return authProvider.isAuthenticated
                        ? _buildUserProfile(authProvider)
                        : const SizedBox(width: 46); // Placeholder for balance
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return AnimatedBuilder(
      animation: _backButtonController,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => _backButtonController.forward(),
          onTapUp: (_) => _backButtonController.reverse(),
          onTapCancel: () => _backButtonController.reverse(),
          onTap: () {
            if (widget.onBackPressed != null) {
              widget.onBackPressed!();
            } else {
              Get.back();
            }
          },
          child: Transform.scale(
            scale: 1.0 - (_backButtonController.value * 0.1),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(
                  0.1 + (_backButtonController.value * 0.1)
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: widget.backButtonColor ?? AppTheme.primaryGreen,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserProfile(AuthProvider authProvider) {
    final user = authProvider.currentUser;
    final userName = user?.name ?? 'User';
    final userInitials = _getInitials(userName);

    return CompositedTransformTarget(
      link: _layerLink,
      child: AnimatedBuilder(
        animation: _profileController,
        builder: (context, child) {
          return GestureDetector(
            onTapDown: (_) => _profileController.forward(),
            onTapUp: (_) => _profileController.reverse(),
            onTapCancel: () => _profileController.reverse(),
            onTap: _toggleDropdown,
            child: Transform.scale(
              scale: 1.0 - (_profileController.value * 0.05),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isDropdownOpen 
                        ? AppTheme.accentYellow 
                        : AppTheme.primaryGreen,
                    width: 2,
                  ),
                  boxShadow: _isDropdownOpen ? [
                    BoxShadow(
                      color: AppTheme.accentYellow.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ] : null,
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primaryGreen,
                  child: Text(
                    userInitials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0].substring(0, words[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'U';
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    if (_isDropdownOpen) {
      _overlayEntry.remove();
      setState(() {
        _isDropdownOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final theme = Theme.of(context);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: 260,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(-210, size.height + 8),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            builder: (context, animation, child) {
              return Transform.scale(
                scale: 0.95 + (animation * 0.05),
                child: Opacity(
                  opacity: animation,
                  child: Material(
                    elevation: 12,
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    shadowColor: Colors.black26,
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        final user = authProvider.currentUser;
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.borderColor,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // User Info Header
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppTheme.primaryGreen.withOpacity(0.05),
                                      AppTheme.accentYellow.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppTheme.primaryGreen,
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppTheme.primaryGreen,
                                        child: Text(
                                          _getInitials(user?.name ?? 'User'),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user?.name ?? 'User',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.primaryText,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            user?.email ?? 'user@example.com',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: AppTheme.mutedText,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.successColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'En ligne',
                                              style: theme.textTheme.labelSmall?.copyWith(
                                                color: AppTheme.successColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Menu Items
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  children: [
                                    _buildDropdownItem(
                                      Icons.dashboard_outlined,
                                      'Dashboard',
                                      () {
                                        _closeDropdown();
                                        Get.toNamed(AppRoutes.dashboard);
                                      },
                                    ),
                                    _buildDropdownItem(
                                      Icons.person_outline,
                                      'Profile',
                                      () {
                                        _closeDropdown();
                                        Get.toNamed(AppRoutes.profile);
                                      },
                                    ),
                                    _buildDropdownItem(
                                      Icons.settings_outlined,
                                      'Paramètres',
                                      () {
                                        _closeDropdown();
                                        // Navigate to settings
                                      },
                                    ),
                                    
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                      height: 1,
                                      color: AppTheme.borderColor,
                                    ),
                                    
                                    _buildDropdownItem(
                                      Icons.logout_outlined,
                                      'Se déconnecter',
                                      () {
                                        _closeDropdown();
                                        _handleLogout(authProvider);
                                      },
                                      isDestructive: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDestructive 
                    ? AppTheme.errorColor.withOpacity(0.1)
                    : AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: isDestructive ? AppTheme.errorColor : AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isDestructive ? AppTheme.errorColor : AppTheme.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(AuthProvider authProvider) async {
    final theme = Theme.of(context);
    
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Se déconnecter',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryText,
          ),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Annuler',
              style: TextStyle(color: AppTheme.mutedText),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await authProvider.logout();
      // Get.offAllNamed(AppRoutes.splash);
    }
  }
}