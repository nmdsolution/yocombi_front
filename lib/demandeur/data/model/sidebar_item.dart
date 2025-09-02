// lib/core/models/sidebar_item.dart
import 'package:flutter/material.dart';

class SidebarItem {
  final String id;
  final String title;
  final IconData icon;
  final String route;
  final String? badge;
  final bool isActive;
  final VoidCallback? onTap;

  const SidebarItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    this.badge,
    this.isActive = false,
    this.onTap,
  });

  SidebarItem copyWith({
    String? id,
    String? title,
    IconData? icon,
    String? route,
    String? badge,
    bool? isActive,
    VoidCallback? onTap,
  }) {
    return SidebarItem(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      badge: badge ?? this.badge,
      isActive: isActive ?? this.isActive,
      onTap: onTap ?? this.onTap,
    );
  }
}