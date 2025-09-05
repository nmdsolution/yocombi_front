// lib/core/controllers/sidebar_controller.dart
// REPLACE YOUR ENTIRE FILE WITH THIS CODE

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../data/constant/sidebar_configs.dart';
import '../../data/model/sidebar_config.dart';

class SidebarController extends GetxController {
  final RxString _hoveredItem = ''.obs;
  final RxString _currentRoute = Get.currentRoute.obs;
  
  String get hoveredItem => _hoveredItem.value;
  String get currentRoute => _currentRoute.value;

  void updateCurrentRoute(String route) {
    // Check if we're currently in the build phase
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      // We're in the build phase, schedule the update for after build completes
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_currentRoute.value != route) {
          _currentRoute.value = route;
        }
      });
    } else {
      // Safe to update immediately
      if (_currentRoute.value != route) {
        _currentRoute.value = route;
      }
    }
  }

  // Alternative method that always defers the update (safer approach)
  void updateCurrentRouteSafe(String route) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_currentRoute.value != route) {
        _currentRoute.value = route;
      }
    });
  }

  void setHoveredItem(String itemId) {
    _hoveredItem.value = itemId;
  }

  void clearHoveredItem() {
    _hoveredItem.value = '';
  }

  bool isItemActive(String route) {
    return _currentRoute.value == route;
  }

  bool isItemHovered(String itemId) {
    return _hoveredItem.value == itemId;
  }

  SidebarConfig getConfig(String userType) {
    switch (userType.toLowerCase()) {
      case 'demandeur':
        return SidebarConfigs.getDemandeurConfig(_currentRoute.value);
      case 'travailleur':
        return SidebarConfigs.getTravailleurConfig(_currentRoute.value);
      default:
        return SidebarConfigs.getDemandeurConfig(_currentRoute.value);
    }
  }

  void navigateToRoute(String route) {
    if (route != _currentRoute.value) {
      Get.toNamed(route);
      // Update route safely after navigation
      updateCurrentRouteSafe(route);
    }
  }

  void showSwitchDialog({
    required BuildContext context,
    required String targetUserType,
    required String targetRoute,
  }) {
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
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            'Vous allez passer en mode ${targetUserType.capitalize}. Voulez-vous continuer ?',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.offNamed(targetRoute);
              },
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
  }
}