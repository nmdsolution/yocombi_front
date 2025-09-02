// lib/core/constants/sidebar_configs.dart
import 'package:flutter/material.dart';
import '../../../core/routes/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../model/sidebar_config.dart';
import '../model/sidebar_item.dart';


class SidebarConfigs {
  static SidebarConfig getDemandeurConfig(String currentRoute) {
    return SidebarConfig(
      userType: 'demandeur',
      logoText: 'YoCombi!',
      userTypeLabel: 'Demandeur',
      logoIcon: Icons.handyman,
      primaryColor: AppTheme.primaryGreen,
      accentColor: AppTheme.accentYellow,
      menuItems: [
        SidebarItem(
          id: 'dashboard',
          title: 'Tableau de bord',
          icon: Icons.dashboard,
          route: AppRoutes.demandeurDashboard,
          isActive: currentRoute == AppRoutes.demandeurDashboard,
        ),
        SidebarItem(
          id: 'requests',
          title: 'Mes demandes',
          icon: Icons.work,
          route: AppRoutes.mesDemande,
          isActive: currentRoute == AppRoutes.mesDemande,
          badge: '5', // Could be dynamic
        ),
       /* SidebarItem(
          id: 'new_request',
          title: 'Nouvelle demande',
          icon: Icons.add_circle_outline,
          route: AppRoutes.newmDemande,
          isActive: currentRoute == AppRoutes.newmDemande,
        ),*/
        SidebarItem(
          id: 'broullion',
          title: 'broullion',
          icon: Icons.drafts_outlined,
          route: AppRoutes.broullion,
          isActive: currentRoute == AppRoutes.broullion,
        ),
        SidebarItem(
          id: 'settings',
          title: 'Paramètres',
          icon: Icons.settings_outlined,
          route: AppRoutes.demandeurSettings,
          isActive: currentRoute == AppRoutes.demandeurSettings,
        ),
      ],
      bottomAction: SidebarItem(
        id: 'switch_to_worker',
        title: 'DEVENIR TRAVAILLEUR',
        icon: Icons.work_outline,
        route: AppRoutes.travailleurDashboard,
      ),
    );
  }

  static SidebarConfig getTravailleurConfig(String currentRoute) {
    return SidebarConfig(
      userType: 'travailleur',
      logoText: 'YoCombi!',
      userTypeLabel: 'Travailleur',
      logoIcon: Icons.construction,
      primaryColor: AppTheme.primaryGreen,
      accentColor: AppTheme.accentYellow,
      menuItems: [
        SidebarItem(
          id: 'dashboard',
          title: 'Tableau de bord',
          icon: Icons.dashboard,
          route: AppRoutes.travailleurDashboard,
          isActive: currentRoute == AppRoutes.travailleurDashboard,
        ),
        SidebarItem(
          id: 'missions',
          title: 'Mes missions',
          icon: Icons.assignment,
          route: AppRoutes.travailleurMissions,
          isActive: currentRoute == AppRoutes.travailleurMissions,
          badge: '3',
        ),
        SidebarItem(
          id: 'new_mission',
          title: 'Nouvelle mission',
          icon: Icons.add_task,
          route: AppRoutes.travailleurNewMission,
          isActive: currentRoute == AppRoutes.travailleurNewMission,
        ),
        SidebarItem(
          id: 'location',
          title: 'Localisation',
          icon: Icons.location_on_outlined,
          route: AppRoutes.travailleurLocation,
          isActive: currentRoute == AppRoutes.travailleurLocation,
        ),
        SidebarItem(
          id: 'settings',
          title: 'Paramètres',
          icon: Icons.settings_outlined,
          route: AppRoutes.travailleurSettings,
          isActive: currentRoute == AppRoutes.travailleurSettings,
        ),
      ],
      bottomAction: SidebarItem(
        id: 'switch_to_demandeur',
        title: 'DEVENIR DEMANDEUR',
        icon: Icons.person_outline,
        route: AppRoutes.demandeurDashboard,
      ),
    );
  }
}