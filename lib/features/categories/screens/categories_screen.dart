import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../inventory/screens/inventory_screen.dart';
import '../../inventory/data/mock_inventory.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<_Category> _buildCategories() {
  const categoryNames = [
    'Rifle',
    'Pistol',
    'Sniper Rifle',
    'Shotgun',
  ];

  return categoryNames.map((name) {
    final products = MockInventory.items
        .where((product) => product.category == name)
        .toList();

    final availableItems = products
        .where((product) => product.status == 'Available')
        .length;

    return _Category(
      name: name,
      description: _categoryDescription(name),
      totalItems: products.length,
      availableItems: availableItems,
    );
  }).toList();
}

  String _searchQuery = '';

  String _categoryDescription(String category) {
  switch (category) {
    case 'Rifle':
      return 'Rifle inventory';
    case 'Pistol':
      return 'Pistol inventory';
    case 'Sniper Rifle':
      return 'Sniper rifle inventory';
    case 'Shotgun':
      return 'Shotgun inventory';
    default:
      return 'Inventory category';
  }
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _buildCategories();
    final filteredCategories = categories.where((category) {
      final query = _searchQuery.toLowerCase();

      return category.name.toLowerCase().contains(query) ||
          category.description.toLowerCase().contains(query);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: AppSpacing.xl),

              _buildSummary(),

              const SizedBox(height: AppSpacing.xl),

              _buildSearch(),

              const SizedBox(height: AppSpacing.lg),

              if (filteredCategories.isEmpty)
                _buildEmptyState()
              else
                _buildCategoryGrid(filteredCategories),
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
        Text('Categories', style: AppTextStyles.headline),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Manage and explore fictional inventory categories.',
          style: AppTextStyles.bodySecondary,
        ),
      ],
    );
  }

  Widget _buildSummary() {
  final categories = _buildCategories();

  final totalItems = MockInventory.items.length;

  final availableItems = MockInventory.items
      .where((product) => product.status == 'Available')
      .length;

  return LayoutBuilder(
    builder: (context, constraints) {
      final isCompact = constraints.maxWidth < 600;

      final cards = [
        _SummaryCard(
          icon: Icons.category_outlined,
          title: 'Total Categories',
          value: '${categories.length}',
        ),
        _SummaryCard(
          icon: Icons.inventory_2_outlined,
          title: 'Total Items',
          value: '$totalItems',
        ),
        _SummaryCard(
          icon: Icons.check_circle_outline,
          title: 'Available Items',
          value: '$availableItems',
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

  Widget _buildSearch() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: const InputDecoration(
        hintText: 'Search categories...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget _buildCategoryGrid(List<_Category> filteredCategories) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 800 ? 2 : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredCategories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            mainAxisExtent: 230,
          ),
          itemBuilder: (context, index) {
            return _CategoryCard(
              category: filteredCategories[index],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Material(
                      color: AppColors.background,
                      child: InventoryScreen(
                        initialCategory: filteredCategories[index].name,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.search_off_outlined,
                size: 48,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('No categories found', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Try another search keyword.',
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _Category category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final availability = category.totalItems == 0
      ? 0.0
      : category.availableItems / category.totalItems;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.category_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category.name, style: AppTextStyles.title),
                        const SizedBox(height: 2),
                        Text(
                          category.description,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _CategoryMetric(
                      label: 'Total Items',
                      value: '${category.totalItems}',
                    ),
                  ),
                  Expanded(
                    child: _CategoryMetric(
                      label: 'Available',
                      value: '${category.availableItems}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: availability,
                  minHeight: 6,
                  backgroundColor: AppColors.border,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${(availability * 100).round()}% available',
                      style: AppTextStyles.caption,
                    ),
                  ),
                  const Text(
                    'View inventory',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryMetric extends StatelessWidget {
  final String label;
  final String value;

  const _CategoryMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTextStyles.title),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: AppTextStyles.title),
                  const SizedBox(height: 2),
                  Text(title, style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Category {
  final String name;
  final String description;
  final int totalItems;
  final int availableItems;

  const _Category({
    required this.name,
    required this.description,
    required this.totalItems,
    required this.availableItems,
  });
}
