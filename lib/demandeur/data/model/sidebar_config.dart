
// lib/core/models/sidebar_config.dart
import 'package:flutter/material.dart';

import 'sidebar_item.dart';

class SidebarConfig {
  final String userType;
  final String logoText;
  final String userTypeLabel;
  final IconData logoIcon;
  final List<SidebarItem> menuItems;
  final SidebarItem? bottomAction;
  final Color primaryColor;
  final Color accentColor;

  const SidebarConfig({
    required this.userType,
    required this.logoText,
    required this.userTypeLabel,
    required this.logoIcon,
    required this.menuItems,
    this.bottomAction,
    required this.primaryColor,
    required this.accentColor,
  });
}