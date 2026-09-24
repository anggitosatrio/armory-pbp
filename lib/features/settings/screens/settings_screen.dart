import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool compactMode = false;
  bool animationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: AppTextStyles.headline,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Configure the ARMORY interface and application preferences.',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: AppSpacing.xl),

              _buildAppearanceSection(),

              const SizedBox(height: AppSpacing.lg),

              _buildInterfaceSection(),

              const SizedBox(height: AppSpacing.lg),

              _buildSystemSection(),

              const SizedBox(height: AppSpacing.lg),

              _buildAboutSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return _SettingsSection(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        _SettingsRow(
          title: 'Theme',
          description: 'Current application appearance.',
          trailing: const _SettingsValue(
            value: 'Dark Tactical',
          ),
        ),
      ],
    );
  }

  Widget _buildInterfaceSection() {
    return _SettingsSection(
      title: 'Interface',
      icon: Icons.tune_outlined,
      children: [
        _SettingsRow(
          title: 'Compact Mode',
          description: 'Reduce spacing across the application interface.',
          trailing: Switch(
            value: compactMode,
            onChanged: (value) {
              setState(() {
                compactMode = value;
              });
            },
          ),
        ),
        const Divider(
          color: AppColors.border,
          height: 1,
        ),
        _SettingsRow(
          title: 'Animations',
          description: 'Enable interface transition animations.',
          trailing: Switch(
            value: animationsEnabled,
            onChanged: (value) {
              setState(() {
                animationsEnabled = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSystemSection() {
    return _SettingsSection(
      title: 'System',
      icon: Icons.settings_outlined,
      children: const [
        _SettingsRow(
          title: 'Application Version',
          description: 'Current ARMORY application version.',
          trailing: _SettingsValue(
            value: 'v1.0.0',
          ),
        ),
        Divider(
          color: AppColors.border,
          height: 1,
        ),
        _SettingsRow(
          title: 'Environment',
          description: 'Current application environment.',
          trailing: _SettingsValue(
            value: 'Demo',
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _SettingsSection(
      title: 'About',
      icon: Icons.info_outline,
      children: const [
        _SettingsRow(
          title: 'ARMORY',
          description: 'Tactical Inventory System',
          trailing: Icon(
            Icons.shield_outlined,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: 21,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: AppTextStyles.title,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String title;
  final String description;
  final Widget trailing;

  const _SettingsRow({
    required this.title,
    required this.description,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          trailing,
        ],
      ),
    );
  }
}

class _SettingsValue extends StatelessWidget {
  final String value;

  const _SettingsValue({
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Text(
        value,
        style: AppTextStyles.bodySecondary,
      ),
    );
  }
}