import 'package:flutter/foundation.dart';

import '../data/mock_inventory.dart';
import '../models/product.dart';

class InventoryController extends ChangeNotifier {
  List<Product> get items => MockInventory.items;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedStatus => _selectedStatus;

  List<Product> get filteredItems {
    final query = _searchQuery.trim().toLowerCase();

    return items.where((product) {
      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.manufacturer.toLowerCase().contains(query) ||
          product.model.toLowerCase().contains(query) ||
          product.id.toLowerCase().contains(query);

      final matchesCategory =
          _selectedCategory == 'All' ||
          product.category == _selectedCategory;

      final matchesStatus =
          _selectedStatus == 'All' ||
          product.status == _selectedStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  void setStatus(String value) {
    _selectedStatus = value;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedStatus = 'All';
    notifyListeners();
  }

  void addProduct(Product product) {
    MockInventory.items.add(product);
    notifyListeners();
  }

  void updateProduct(Product updatedProduct) {
    final index = MockInventory.items.indexWhere(
      (product) => product.id == updatedProduct.id,
    );

    if (index == -1) return;

    MockInventory.items[index] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct(String productId) {
    MockInventory.items.removeWhere(
      (product) => product.id == productId,
    );

    notifyListeners();
  }
}