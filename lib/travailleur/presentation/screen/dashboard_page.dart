// lib/TravailleurPro/presentation/dashboard/dashboard_page.dart (FIXED)
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../../core/widgets/top_navbar.dart';
import '../../../core/routes/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../demandeur/presentation/controllers/sidebar_controller.dart';
import '../../../demandeur/presentation/widget/universal_sidebar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initAnimations();
  }

  void _initControllers() {
    // Initialize sidebar controller if not already done
    if (!Get.isRegistered<SidebarController>()) {
      Get.put(SidebarController());
    }
    
    // Use the safe update method that always defers the update
    Get.find<SidebarController>().updateCurrentRouteSafe(AppRoutes.travailleurDashboard);
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: PageHeader(
        title: 'Dashboard Travailleur',
        showBackButton: true,
        showUserProfile: true,
        backgroundColor: Colors.white,
        titleColor: AppTheme.primaryText,
        backButtonColor: AppTheme.primaryGreen,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          // Universal Sidebar for Travailleur
          const UniversalSidebar(
            userType: 'travailleur',
          ),
          // Main Content
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tableau de Bord - Travailleur',
                        style: theme.textTheme.headlineLarge,
                      ),
                      // Status indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.successColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.online_prediction,
                              color: AppTheme.successColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'En ligne',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Stats Cards
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 32,
                    children: [
                      _buildStatsCard(
                        Icons.work_outline,
                        '3',
                        'Missions actives',
                        AppTheme.primaryGreen,
                        AppTheme.primaryGreen.withOpacity(0.1),
                        0,
                      ),
                      _buildStatsCard(
                        Icons.check_circle_outline,
                        '18',
                        'Missions terminées',
                        AppTheme.successColor,
                        AppTheme.successColor.withOpacity(0.1),
                        1,
                      ),
                      _buildStatsCard(
                        Icons.schedule_outlined,
                        '2',
                        'En attente validation',
                        AppTheme.warningColor,
                        AppTheme.warningColor.withOpacity(0.1),
                        2,
                      ),
                      _buildStatsCard(
                        Icons.star_outline,
                        '4.8',
                        'Note moyenne',
                        AppTheme.accentYellow,
                        AppTheme.accentYellow.withOpacity(0.1),
                        3,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Recent Missions Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Missions récentes',
                                style: theme.textTheme.titleLarge,
                              ),
                              TextButton.icon(
                                onPressed: () => Get.toNamed(AppRoutes.travailleurMissions),
                                icon: const Icon(Icons.arrow_forward, size: 16),
                                label: const Text('Voir tout'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildMissionRow('Réparation plomberie', 'En cours', AppTheme.primaryGreen),
                          _buildMissionRow('Installation électrique', 'Terminée', AppTheme.successColor),
                          _buildMissionRow('Nettoyage bureau', 'En attente', AppTheme.warningColor),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Quick Actions
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Actions rapides',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => Get.toNamed(AppRoutes.travailleurMissions),
                                  icon: const Icon(Icons.search, size: 18),
                                  label: const Text('Chercher missions'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => Get.toNamed(AppRoutes.travailleurLocation),
                                  icon: const Icon(Icons.location_on, size: 18),
                                  label: const Text('Mettre à jour position'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(
    IconData icon,
    String value,
    String label,
    Color iconColor,
    Color bgColor,
    int index,
  ) {
    final theme = Theme.of(context);
    
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, animation, child) {
        return Transform.scale(
          scale: animation,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 32,
                            color: AppTheme.primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ],
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

  Widget _buildMissionRow(String title, String status, Color statusColor) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: theme.textTheme.labelSmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}