import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../features/auth/models/permissions.dart';
import '../../../features/auth/models/user.dart';

class DesktopSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final UserRole role;

  const DesktopSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBrand(),
            const SizedBox(height: AppSpacing.lg),
            _buildNavigation(),
            const Spacer(),
            _buildVersion(),
          ],
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            color: AppColors.primary,
            size: 30,
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            'ARMORY',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    final items = <_SidebarItem>[
      _SidebarItem(
        index: 0,
        icon: Icons.dashboard_outlined,
        label: 'Dashboard',
        permission: AppPermission.viewDashboard,
      ),
      _SidebarItem(
        index: 1,
        icon: Icons.inventory_2_outlined,
        label: 'Inventory',
        permission: AppPermission.viewInventory,
      ),
      _SidebarItem(
        index: 2,
        icon: Icons.person_outline,
        label: 'Profile',
        permission: AppPermission.viewProfile,
      ),
      _SidebarItem(
        index: 3,
        icon: Icons.category_outlined,
        label: 'Categories',
        permission: AppPermission.viewCategories,
      ),
      _SidebarItem(
        index: 4,
        icon: Icons.settings_outlined,
        label: 'Settings',
        permission: AppPermission.viewSettings,
      ),
    ];

    return Column(
      children: [
        for (final item in items)
          _buildItem(
            index: item.index,
            icon: item.icon,
            label: item.label,
          ),
      ],
    );
  }

  Widget _buildItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      child: Material(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onItemSelected(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 12,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVersion() {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Text(
        'ARMORY v1.0.0',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _SidebarItem {
  final int index;
  final IconData icon;
  final String label;
  final AppPermission permission;

  const _SidebarItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.permission,
  });
}