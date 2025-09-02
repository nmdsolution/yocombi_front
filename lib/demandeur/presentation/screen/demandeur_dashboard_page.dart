// lib/presentation/demandeur/demandeur_dashboard_page.dart (Fixed)
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Add this import
import 'package:get/get.dart';

import '../../../core/routes/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/top_navbar.dart';
import '../controllers/sidebar_controller.dart';
import '../widget/universal_sidebar.dart';

class DemandeurDashboardPage extends StatefulWidget {
  const DemandeurDashboardPage({super.key});

  @override
  State<DemandeurDashboardPage> createState() => _DemandeurDashboardPageState();
}

class _DemandeurDashboardPageState extends State<DemandeurDashboardPage>
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
  Get.find<SidebarController>().updateCurrentRouteSafe(AppRoutes.demandeurDashboard);
  // OR for other pages: AppRoutes.newmDemande, AppRoutes.mesDemande, etc.
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
        title: 'Dashboard Demandeur',
        showBackButton: true,
        showUserProfile: true,
        backgroundColor: Colors.white,
        titleColor: AppTheme.primaryText,
        backButtonColor: AppTheme.primaryGreen,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          // Universal Sidebar
          const UniversalSidebar(
            userType: 'demandeur',
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
                        'Tableau de Bord - Demandeur',
                        style: theme.textTheme.headlineLarge,
                      ),
                      ElevatedButton.icon(
                        onPressed: _handleNewRequest,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Nouvelle Demande'),
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
                        Icons.assignment,
                        '5',
                        'Demandes actives',
                        AppTheme.primaryGreen,
                        AppTheme.primaryGreen.withOpacity(0.1),
                        0,
                      ),
                      _buildStatsCard(
                        Icons.check_circle,
                        '15',
                        'Demandes terminées',
                        AppTheme.successColor,
                        AppTheme.successColor.withOpacity(0.1),
                        1,
                      ),
                      _buildStatsCard(
                        Icons.hourglass_empty,
                        '2',
                        'En attente',
                        AppTheme.warningColor,
                        AppTheme.warningColor.withOpacity(0.1),
                        2,
                      ),
                      _buildStatsCard(
                        Icons.people,
                        '8',
                        'Travailleurs trouvés',
                        AppTheme.accentYellow,
                        AppTheme.accentYellow.withOpacity(0.1),
                        3,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Recent Requests Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Demandes récentes',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildRequestRow('Réparation plomberie', 'En cours', AppTheme.primaryGreen),
                          _buildRequestRow('Nettoyage bureau', 'Terminée', AppTheme.successColor),
                          _buildRequestRow('Jardinage', 'En attente', AppTheme.warningColor),
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

  Widget _buildRequestRow(String title, String status, Color statusColor) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
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

  void _handleNewRequest() {
    Get.toNamed(AppRoutes.newmDemande);
  }
}