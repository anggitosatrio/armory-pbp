import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../auth/auth_scope.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _formatRole(UserRole role) {
    switch (role) {
      case UserRole.administrator:
        return 'Administrator';
      case UserRole.operator:
        return 'Operator';
      case UserRole.viewer:
        return 'Viewer';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Profile', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Manage your ARMORY account information.',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildProfileCard(auth),
              const SizedBox(height: AppSpacing.lg),
              _buildLogoutCard(auth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(AuthController auth) {
    final user = auth.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.35),
                    ),
                  ),
                child: user.profileImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      user.profileImage!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person_outline,
                          size: 38,
                          color: AppColors.primary,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.person_outline,
                    size: 38,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: AppTextStyles.title),
                      const SizedBox(height: AppSpacing.xs),
                      Text(user.email, style: AppTextStyles.bodySecondary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const Divider(color: AppColors.border),
            const SizedBox(height: AppSpacing.lg),
            _buildInfoRow(label: 'Role', value: _formatRole(user.role)),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow(label: 'Account ID', value: user.id),
            const SizedBox(height: AppSpacing.md),
            const _ProfileStatusRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.bodySecondary)),
        Text(value, style: AppTextStyles.body),
      ],
    );
  }

  Widget _buildLogoutCard(AuthController auth) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sign out', style: AppTextStyles.title),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'End your current ARMORY session.',
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: auth.logout,
              icon: const Icon(Icons.logout),
              label: const Text('LOGOUT'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStatusRow extends StatelessWidget {
  const _ProfileStatusRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Status',
            style: AppTextStyles.bodySecondary,
          ),
        ),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'Active',
              style: TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
