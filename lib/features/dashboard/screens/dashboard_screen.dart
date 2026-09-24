import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../features/inventory/data/mock_inventory.dart';
import '../../../features/inventory/models/product.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1400,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.xl),
              _buildSummarySection(),
              const SizedBox(height: AppSpacing.xl),
              _buildContentSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: AppTextStyles.headline,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Overview of your tactical inventory system.',
          style: AppTextStyles.bodySecondary,
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
  final totalItems = MockInventory.items.length;

  final totalCategories = {
    'Rifle',
    'Pistol',
    'Sniper Rifle',
    'Shotgun',
  }.length;

  final availableItems = MockInventory.items
      .where((product) => product.status == 'Available')
      .length;

  return LayoutBuilder(
    builder: (context, constraints) {
      final isCompact = constraints.maxWidth < 700;

      final cards = [
        _SummaryCard(
          title: 'Total Items',
          value: '$totalItems',
          icon: Icons.inventory_2_outlined,
        ),
        _SummaryCard(
          title: 'Categories',
          value: '$totalCategories',
          icon: Icons.category_outlined,
        ),
        _SummaryCard(
          title: 'Available',
          value: '$availableItems',
          icon: Icons.check_circle_outline,
        ),
      ];

      if (isCompact) {
        return Column(
          children: [
            for (final card in cards) ...[
              card,
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        );
      }

      return Row(
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            Expanded(child: cards[i]),
            if (i < cards.length - 1)
              const SizedBox(width: AppSpacing.md),
          ],
        ],
      );
    },
  );
}

  Widget _buildContentSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 900;

        if (isCompact) {
          return const Column(
            children: [
              _RecentInventoryCard(),
              SizedBox(height: AppSpacing.lg),
              _CategoryOverviewCard(),
            ],
          );
        }

        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _RecentInventoryCard(),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              flex: 2,
              child: _CategoryOverviewCard(),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.title,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentInventoryCard extends StatelessWidget {
  const _RecentInventoryCard();

  @override
  Widget build(BuildContext context) {
    final recentItems = MockInventory.items.take(4).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Inventory',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final product in recentItems)
              _InventoryRow(product: product),
          ],
        ),
      ),
    );
  }
}

class _InventoryRow extends StatelessWidget {
  final Product product;

  const _InventoryRow({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = product.status == 'Available';

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              product.imagePath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 24,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.category,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            product.status,
            style: TextStyle(
              color: isAvailable
                  ? AppColors.success
                  : AppColors.warning,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryOverviewCard extends StatelessWidget {
  const _CategoryOverviewCard();

  @override
  Widget build(BuildContext context) {
    const categories = [
      'Rifle',
      'Pistol',
      'Sniper Rifle',
      'Shotgun',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final category in categories)
              _CategoryRow(
                name: category,
                count: '${MockInventory.items.where(
                  (product) => product.category == category,
                ).length}',
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String name;
  final String count;

  const _CategoryRow({
    required this.name,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.body,
            ),
          ),
          Text(
            count,
            style: AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }
}