// lib/presentation/dashboard/widgets/dashboard_sidebar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/routes.dart';
import '../../../core/theme/app_theme.dart';

class DashboardSidebar extends StatefulWidget {
  final int selectedNavIndex;
  final Function(int) onNavItemSelected;

  const DashboardSidebar({
    super.key,
    required this.selectedNavIndex,
    required this.onNavItemSelected,
  });

  @override
  State<DashboardSidebar> createState() => _DashboardSidebarState();
}

class _DashboardSidebarState extends State<DashboardSidebar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 256,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.borderColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // YoCombi Logo for Travailleur
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.construction,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YoCombi!',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 20,
                            color: AppTheme.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Travailleur',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.mutedText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Navigation Menu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                children: [
                  _buildNavItem(0, Icons.dashboard, 'Tableau de bord'),
                  _buildNavItem(1, Icons.work_outline, 'Mes missions'),
                  _buildNavItem(3, Icons.location_on_outlined, 'Localisation'),
                  _buildNavItem(4, Icons.settings_outlined, 'Paramètres'),
                  
                  const SizedBox(height: 24),
                  
                  // Section divider
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    height: 1,
                    color: AppTheme.borderColor,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Quick stats or info
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppTheme.accentYellow,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Note: 4.8/5',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.primaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.verified,
                              color: AppTheme.successColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Vérifié',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Button
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.borderColor,
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleBecomeRequester,
                icon: const Icon(Icons.person_outline, size: 18),
                label: const Text('DEVENIR DEMANDEUR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentYellow,
                  foregroundColor: AppTheme.darkGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  textStyle: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String title) {
    final bool isActive = widget.selectedNavIndex == index;
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.onNavItemSelected(index);
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive 
                  ? AppTheme.primaryGreen.withOpacity(0.1) 
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border(
                      left: BorderSide(
                        color: AppTheme.primaryGreen,
                        width: 3,
                      ),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive 
                      ? AppTheme.primaryGreen 
                      : AppTheme.mutedText,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      color: isActive 
                          ? AppTheme.primaryGreen 
                          : AppTheme.mutedText,
                    ),
                  ),
                ),
                if (isActive)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.accentYellow,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleBecomeRequester() {
    // Show a confirmation dialog first
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Changer de mode',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryText,
            ),
          ),
          content: Text(
            'Vous allez passer en mode Demandeur. Voulez-vous continuer ?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Annuler',
                style: TextStyle(color: AppTheme.mutedText),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.offNamed(AppRoutes.demandeurDashboard);
              },
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
  }
}