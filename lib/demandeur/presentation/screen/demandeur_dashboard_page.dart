// lib/presentation/demandeur/pages/demandeur_dashboard_page.dart (Updated with Real Statistics)
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/top_navbar.dart';
import '../../../job-offers/providers/job_offer_provider.dart';
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
  
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initAnimations();
    _loadDashboardData();
  }

  void _initControllers() {
    if (!Get.isRegistered<SidebarController>()) {
      Get.put(SidebarController());
    }
    Get.find<SidebarController>().updateCurrentRouteSafe(AppRoutes.demandeurDashboard);
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

  Future<void> _loadDashboardData() async {
    if (!mounted) return;
    
    final provider = Provider.of<JobOfferProvider>(context, listen: false);
    
    // Load my job offers to get real statistics
    await provider.getMyJobOffers();
    
    if (mounted) {
      setState(() {
        _isDataLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMediumScreen = MediaQuery.of(context).size.width > 768;
    
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
      drawer: isMediumScreen ? null : const UniversalSidebar(userType: 'demandeur'),
      body: Row(
        children: [
          // Universal Sidebar - only show on medium+ screens
          if (isMediumScreen)
            const UniversalSidebar(userType: 'demandeur'),
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
    final isMediumScreen = MediaQuery.of(context).size.width > 768;
    
    if (!_isDataLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Consumer<JobOfferProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(isMediumScreen ? 32 : 16),
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
                      Flex(
                        direction: isMediumScreen ? Axis.horizontal : Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: isMediumScreen 
                            ? CrossAxisAlignment.center 
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tableau de Bord - Demandeur',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontSize: isMediumScreen ? null : 24,
                            ),
                          ),
                          if (!isMediumScreen) const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _handleNewRequest,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Nouvelle Demande'),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Stats Cards with real data
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isMediumScreen ? 2 : 1,
                        childAspectRatio: isMediumScreen ? 2.5 : 3.0,
                        crossAxisSpacing: 32,
                        mainAxisSpacing: 32,
                        children: [
                          _buildClickableStatsCard(
                            Icons.publish,
                            provider.myPublishedCount.toString(),
                            'Demandes publiées',
                            Colors.blue,
                            Colors.blue.withOpacity(0.1),
                            0,
                            onTap: () => _navigateToPublishedDemands(),
                          ),
                          _buildStatsCard(
                            Icons.check_circle,
                            provider.myCompletedCount.toString(),
                            'Demandes terminées',
                            AppTheme.successColor,
                            AppTheme.successColor.withOpacity(0.1),
                            1,
                          ),
                          _buildStatsCard(
                            Icons.hourglass_empty,
                            provider.myInProgressCount.toString(),
                            'En cours',
                            AppTheme.warningColor,
                            AppTheme.warningColor.withOpacity(0.1),
                            2,
                          ),
                          _buildStatsCard(
                            Icons.drafts,
                            provider.myDraftCount.toString(),
                            'Brouillons',
                            AppTheme.mutedText,
                            AppTheme.mutedText.withOpacity(0.1),
                            3,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Recent Requests Section with real data
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
                                    'Demandes récentes',
                                    style: theme.textTheme.titleLarge,
                                  ),
                                  TextButton(
                                    onPressed: () => Get.toNamed(AppRoutes.mesDemande),
                                    child: Text(
                                      'Voir tout',
                                      style: TextStyle(color: AppTheme.primaryGreen),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (provider.myJobOffers.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.work_outline,
                                          size: 48,
                                          color: AppTheme.mutedText,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Aucune demande trouvée',
                                          style: TextStyle(
                                            color: AppTheme.mutedText,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                ...provider.myJobOffers.take(5).map((job) =>
                                  _buildRequestRow(
                                    job.title, 
                                    _getStatusLabel(job.status), 
                                    _getStatusColor(job.status),
                                    job.formattedPrice,
                                    job.deadline,
                                  )
                                ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Quick Actions Section
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
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  _buildQuickActionButton(
                                    Icons.add_circle_outline,
                                    'Nouvelle Demande',
                                    AppTheme.primaryGreen,
                                    () => _handleNewRequest(),
                                  ),
                                  _buildQuickActionButton(
                                    Icons.list_alt,
                                    'Mes Demandes',
                                    Colors.blue,
                                    () => Get.toNamed(AppRoutes.mesDemande),
                                  ),
                                  _buildQuickActionButton(
                                    Icons.drafts,
                                    'Brouillons',
                                    AppTheme.mutedText,
                                    () => Get.toNamed(AppRoutes.broullion),
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
      },
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

  Widget _buildClickableStatsCard(
    IconData icon,
    String value,
    String label,
    Color iconColor,
    Color bgColor,
    int index,
    {VoidCallback? onTap}
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
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
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
                    if (onTap != null)
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppTheme.mutedText,
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

  Widget _buildRequestRow(String title, String status, Color statusColor, String price, DateTime deadline) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              _formatDate(deadline),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.mutedText,
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

  Widget _buildQuickActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
        elevation: 0,
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return 'Brouillon';
      case 'published':
        return 'Publié';
      case 'in_progress':
        return 'En cours';
      case 'completed':
        return 'Terminé';
      case 'cancelled':
        return 'Annulé';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return AppTheme.mutedText;
      case 'published':
        return Colors.blue;
      case 'in_progress':
        return AppTheme.warningColor;
      case 'completed':
        return AppTheme.successColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.mutedText;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _navigateToPublishedDemands() {
    Get.toNamed(AppRoutes.publishedDemandes);
  }

  void _handleNewRequest() {
    Get.toNamed(AppRoutes.newmDemande);
  }}