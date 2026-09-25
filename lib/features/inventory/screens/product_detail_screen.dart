import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Future<Product?> Function()? onEdit;
  final Future<bool> Function()? onDelete;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  Future<void> _handleDelete() async {
  final onDelete = widget.onDelete;

  if (onDelete == null) {
    return;
  }

  final deleted = await onDelete();

  if (deleted && mounted) {
    Navigator.of(context).pop();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1200,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 800;

                if (isCompact) {
                  return _buildCompactLayout();
                }

                return _buildDesktopLayout();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _buildImageSection(),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          flex: 5,
          child: _buildInformationSection(),
        ),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageSection(),
        const SizedBox(height: AppSpacing.xl),
        _buildInformationSection(),
      ],
    );
  }

  Widget _buildImageSection() {
  return Card(
    clipBehavior: Clip.antiAlias,
    child: AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: AppColors.surfaceElevated,
        child: Image.asset(
          _product.imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 96,
                color: AppColors.textSecondary,
              ),
            );
          },
        ),
      ),
    ),
  );
}

  Widget _buildInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _product.name,
          style: AppTextStyles.display,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _product.description,
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: AppSpacing.xl),
      _buildStatus(),
      const SizedBox(height: AppSpacing.lg),
      _buildActionButtons(),
      const SizedBox(height: AppSpacing.xl),
      _buildDetailsCard(),
      ],
    );
  }

  Widget _buildActionButtons() {
  return Row(
    children: [
      FilledButton.icon(
        onPressed: _handleEdit,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('EDIT PRODUCT'),
      ),
      const SizedBox(width: AppSpacing.md),
      OutlinedButton.icon(
        onPressed: _handleDelete,
        icon: const Icon(Icons.delete_outline),
        label: const Text('DELETE PRODUCT'),
      ),
    ],
  );
}

Future<void> _handleEdit() async {
  final onEdit = widget.onEdit;

  if (onEdit == null) {
    return;
  }

  final updatedProduct = await onEdit();

  if (updatedProduct != null && mounted) {
    setState(() {
      _product = updatedProduct;
    });
  }
}

  Widget _buildStatus() {
    final isAvailable = _product.status == 'Available';

    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: isAvailable
                ? AppColors.success
                : AppColors.warning,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          _product.status,
          style: TextStyle(
            color: isAvailable
                ? AppColors.success
                : AppColors.warning,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inventory Information',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildDetailRow(
              label: 'Inventory ID',
              value: _product.id,
            ),
            _buildDetailRow(
              label: 'Category',
              value: _product.category,
            ),
            _buildDetailRow(
              label: 'Manufacturer',
              value: _product.manufacturer,
            ),
            _buildDetailRow(
              label: 'Model',
              value: _product.model,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: AppTextStyles.bodySecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}