// lib/core/widgets/universal_sidebar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../data/model/sidebar_config.dart';
import '../../data/model/sidebar_item.dart';
import '../controllers/sidebar_controller.dart';
class UniversalSidebar extends StatelessWidget {
  final String userType;
  final Function(String)? onItemSelected;

  const UniversalSidebar({
    super.key,
    required this.userType,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SidebarController>();
    
    return Obx(() {
      final config = controller.getConfig(userType);
      
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
            _buildHeader(context, config),
            Expanded(
              child: _buildMenu(context, config, controller),
            ),
            if (config.bottomAction != null)
              _buildBottomAction(context, config, controller),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context, SidebarConfig config) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: config.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              config.logoIcon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.logoText,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 20,
                    color: AppTheme.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  config.userTypeLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.mutedText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(
    BuildContext context,
    SidebarConfig config,
    SidebarController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: config.menuItems
            .map((item) => _buildMenuItem(context, item, config, controller))
            .toList(),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    SidebarItem item,
    SidebarConfig config,
    SidebarController controller,
  ) {
    final theme = Theme.of(context);
    final isActive = controller.isItemActive(item.route);
    final isHovered = controller.isItemHovered(item.id);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.navigateToRoute(item.route);
            onItemSelected?.call(item.route);
          },
          onHover: (hovering) {
            if (hovering) {
              controller.setHoveredItem(item.id);
            } else {
              controller.clearHoveredItem();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive || isHovered
                  ? config.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border(
                      left: BorderSide(
                        color: config.primaryColor,
                        width: 3,
                      ),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isActive || isHovered
                      ? config.primaryColor
                      : AppTheme.mutedText,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      color: isActive || isHovered
                          ? config.primaryColor
                          : AppTheme.mutedText,
                    ),
                  ),
                ),
                if (item.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: config.accentColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badge!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.darkGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isActive && item.badge == null)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: config.accentColor,
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

  Widget _buildBottomAction(
    BuildContext context,
    SidebarConfig config,
    SidebarController controller,
  ) {
    final theme = Theme.of(context);
    
    return Container(
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
          onPressed: () {
            final targetUserType = userType == 'demandeur' ? 'travailleur' : 'demandeur';
            controller.showSwitchDialog(
              context: context,
              targetUserType: targetUserType,
              targetRoute: config.bottomAction!.route,
            );
          },
          icon: Icon(config.bottomAction!.icon, size: 18),
          label: Text(config.bottomAction!.title),
          style: ElevatedButton.styleFrom(
            backgroundColor: config.accentColor,
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
    );
  }
}