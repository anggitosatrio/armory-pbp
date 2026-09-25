import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/inventory_controller.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';

class InventoryScreen extends StatefulWidget {
  final String? initialCategory;

  const InventoryScreen({super.key, this.initialCategory});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final InventoryController _controller = InventoryController();

  @override
  void initState() {
    super.initState();

    if (widget.initialCategory != null) {
      _controller.setCategory(widget.initialCategory!);
    }
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return _AddProductDialog(
          onAdd: (product) {
            _controller.addProduct(product);
          },
        );
      },
    );
  }

  Future<Product?> _showEditProductDialog(Product product) async {
  final updatedProduct = await showDialog<Product?>(
    context: context,
    builder: (context) {
      return _EditProductDialog(
        product: product,
      );
    },
  );

  if (updatedProduct != null) {
    _controller.updateProduct(updatedProduct);
  }

  return updatedProduct;
}

Future<bool> _deleteProduct(Product product) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete ${product.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('DELETE'),
          ),
        ],
      );
    },
  );

  if (confirmed != true) {
    return false;
  }

  _controller.deleteProduct(product.id);
  return true;
}

  bool _isGridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSearchAndFilters(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildResultInfo(),
                  const SizedBox(height: AppSpacing.md),
                  _buildInventoryContent(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.initialCategory != null)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Inventory', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.initialCategory != null
                    ? 'Showing items from ${widget.initialCategory}.'
                    : 'Browse and manage your tactical inventory catalog.',
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        FilledButton.icon(
          onPressed: _showAddProductDialog,
          icon: const Icon(Icons.add),
          label: const Text('ADD PRODUCT'),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: _controller.setSearchQuery,
      decoration: const InputDecoration(
        hintText: 'Search inventory...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final searchWidth = constraints.maxWidth > 700
            ? 400.0
            : constraints.maxWidth;

        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(width: searchWidth, child: _buildSearchField()),
            SizedBox(width: 180, child: _buildCategoryDropdown()),
            SizedBox(width: 180, child: _buildStatusDropdown()),
            _buildViewToggle(),
          ],
        );
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _controller.selectedCategory,
      decoration: const InputDecoration(labelText: 'Type'),
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All Types')),
        DropdownMenuItem(value: 'Rifle', child: Text('Rifle')),
        DropdownMenuItem(value: 'Pistol', child: Text('Pistol')),
        DropdownMenuItem(value: 'Sniper Rifle', child: Text('Sniper Rifle')),
        DropdownMenuItem(value: 'Shotgun', child: Text('Shotgun')),
      ],
      onChanged: (value) {
        if (value == null) {
          return;
        }

        _controller.setCategory(value);
      },
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _controller.selectedStatus,
      decoration: const InputDecoration(labelText: 'Status'),
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All Status')),
        DropdownMenuItem(value: 'Available', child: Text('Available')),
        DropdownMenuItem(value: 'Maintenance', child: Text('Maintenance')),
        DropdownMenuItem(value: 'Reserved', child: Text('Reserved')),
      ],
      onChanged: (value) {
        if (value == null) {
          return;
        }

        _controller.setStatus(value);
      },
    );
  }

  Widget _buildViewToggle() {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment<bool>(
          value: true,
          icon: Icon(Icons.grid_view_outlined),
          label: Text('Grid'),
        ),
        ButtonSegment<bool>(
          value: false,
          icon: Icon(Icons.view_list_outlined),
          label: Text('List'),
        ),
      ],
      selected: {_isGridView},
      onSelectionChanged: (selection) {
        setState(() {
          _isGridView = selection.first;
        });
      },
    );
  }

  Widget _buildResultInfo() {
    final hasFilters =
        _controller.searchQuery.isNotEmpty ||
        _controller.selectedCategory != 'All' ||
        _controller.selectedStatus != 'All';

    return Row(
      children: [
        Text(
          '${_controller.filteredItems.length} items found',
          style: AppTextStyles.bodySecondary,
        ),
        const Spacer(),
        if (hasFilters)
          TextButton.icon(
            onPressed: _resetFilters,
            icon: const Icon(Icons.clear, size: 18),
            label: const Text('Clear filters'),
          ),
      ],
    );
  }

  Widget _buildInventoryContent() {
    final items = _controller.filteredItems;

    if (items.isEmpty) {
      return _buildEmptyState();
    }

    if (!_isGridView) {
      return _buildInventoryList(items);
    }

    return _buildInventoryGrid(items);
  }

  Widget _buildInventoryGrid(List<Product> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int crossAxisCount;

        if (width < 600) {
          crossAxisCount = 1;
        } else if (width < 900) {
          crossAxisCount = 2;
        } else if (width < 1200) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 4;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) {
            final product = items[index];

            return _ProductCard(
              product: product,
              onTap: () => _openProductDetail(product),
            );
          },
        );
      },
    );
  }

  Widget _buildInventoryList(List<Product> items) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) {
          return const Divider(height: 1, color: AppColors.border);
        },
        itemBuilder: (context, index) {
          final product = items[index];

          return _ProductListTile(
            product: product,
            onTap: () => _openProductDetail(product),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.search_off_outlined,
                size: 48,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('No inventory found', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Try changing your search or filter criteria.',
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: _resetFilters,
                child: const Text('Clear filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openProductDetail(Product product) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ProductDetailScreen(
        product: product,
        onEdit: () => _showEditProductDialog(product),
        onDelete: () => _deleteProduct(product),
      ),
    ),
  );
}

  void _resetFilters() {
    _searchController.clear();
    _controller.resetFilters();
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isAvailable = product.status == 'Available';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    color: AppColors.surfaceElevated,
                    child: Image.asset(
                      product.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                product.name,
                style: AppTextStyles.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              Text(
                '${product.category} • ${product.model}',
                style: AppTextStyles.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSpacing.sm),

              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? AppColors.success
                          : AppColors.warning,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),

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

                  const Spacer(),

                  Text(product.id, style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductListTile({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isAvailable = product.status == 'Available';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
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
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(product.manufacturer, style: AppTextStyles.caption),
                ],
              ),
            ),
            Expanded(
              child: Text(product.category, style: AppTextStyles.bodySecondary),
            ),
            Expanded(
              child: Text(product.model, style: AppTextStyles.bodySecondary),
            ),
            SizedBox(
              width: 110,
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? AppColors.success
                          : AppColors.warning,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      product.status,
                      style: TextStyle(
                        color: isAvailable
                            ? AppColors.success
                            : AppColors.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _AddProductDialog extends StatefulWidget {
  final ValueChanged<Product> onAdd;

  const _AddProductDialog({required this.onAdd});

  @override
  State<_AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<_AddProductDialog> {
  final _nameController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _modelController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _category = 'Rifle';
  String _status = 'Available';

  @override
  void dispose() {
    _nameController.dispose();
    _manufacturerController.dispose();
    _modelController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty ||
        _manufacturerController.text.trim().isEmpty ||
        _modelController.text.trim().isEmpty) {
      return;
    }

    final product = Product(
      id: 'ARM-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      category: _category,
      manufacturer: _manufacturerController.text.trim(),
      model: _modelController.text.trim(),
      imagePath: '',
      description: _descriptionController.text.trim(),
      status: _status,
    );

    widget.onAdd(product);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Product'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _manufacturerController,
                decoration: const InputDecoration(labelText: 'Manufacturer'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Model'),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'Rifle', child: Text('Rifle')),
                  DropdownMenuItem(value: 'Pistol', child: Text('Pistol')),
                  DropdownMenuItem(
                    value: 'Sniper Rifle',
                    child: Text('Sniper Rifle'),
                  ),
                  DropdownMenuItem(value: 'Shotgun', child: Text('Shotgun')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _category = value;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(
                    value: 'Available',
                    child: Text('Available'),
                  ),
                  DropdownMenuItem(
                    value: 'Maintenance',
                    child: Text('Maintenance'),
                  ),
                  DropdownMenuItem(value: 'Reserved', child: Text('Reserved')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        FilledButton(onPressed: _submit, child: const Text('ADD PRODUCT')),
      ],
    );
  }
}

class _EditProductDialog extends StatefulWidget {
  final Product product;

  const _EditProductDialog({
    required this.product,
  });

  @override
  State<_EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<_EditProductDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _manufacturerController;
  late final TextEditingController _modelController;
  late final TextEditingController _descriptionController;

  late String _category;
  late String _status;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.product.name,
    );

    _manufacturerController = TextEditingController(
      text: widget.product.manufacturer,
    );

    _modelController = TextEditingController(
      text: widget.product.model,
    );

    _descriptionController = TextEditingController(
      text: widget.product.description,
    );

    _category = widget.product.category;
    _status = widget.product.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _manufacturerController.dispose();
    _modelController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty ||
        _manufacturerController.text.trim().isEmpty ||
        _modelController.text.trim().isEmpty) {
      return;
    }

    final updatedProduct = Product(
      id: widget.product.id,
      name: _nameController.text.trim(),
      category: _category,
      manufacturer: _manufacturerController.text.trim(),
      model: _modelController.text.trim(),
      imagePath: widget.product.imagePath,
      description: _descriptionController.text.trim(),
      status: _status,
    );

    Navigator.of(context).pop(updatedProduct);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Product'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              TextField(
                controller: _manufacturerController,
                decoration: const InputDecoration(
                  labelText: 'Manufacturer',
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              TextField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Model',
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Type',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Rifle',
                    child: Text('Rifle'),
                  ),
                  DropdownMenuItem(
                    value: 'Pistol',
                    child: Text('Pistol'),
                  ),
                  DropdownMenuItem(
                    value: 'Sniper Rifle',
                    child: Text('Sniper Rifle'),
                  ),
                  DropdownMenuItem(
                    value: 'Shotgun',
                    child: Text('Shotgun'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _category = value;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),

              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Available',
                    child: Text('Available'),
                  ),
                  DropdownMenuItem(
                    value: 'Maintenance',
                    child: Text('Maintenance'),
                  ),
                  DropdownMenuItem(
                    value: 'Reserved',
                    child: Text('Reserved'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),

              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('SAVE CHANGES'),
        ),
      ],
    );
  }
}
