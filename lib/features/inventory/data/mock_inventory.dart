import '../models/product.dart';

abstract final class MockInventory {
  static final List<Product> items = [
    Product(
      id: 'ARM-001',
      name: 'AK-47',
      category: 'Rifle',
      manufacturer: 'Kalashnikov',
      model: 'AK-47',
      imagePath: 'assets/images/products/AK47.jpg',
      description:
          'AK-47 displayed as a catalog item within the ARMORY inventory interface.',
      status: 'Available',
    ),
    Product(
      id: 'ARM-002',
      name: 'AR-15',
      category: 'Rifle',
      manufacturer: 'Colt',
      model: 'AR-15',
      imagePath: 'assets/images/products/AR15.jpg',
      description:
          'AR-15 displayed as a catalog item within the ARMORY inventory interface.',
      status: 'Available',
    ),
    Product(
      id: 'ARM-003',
      name: 'Beretta 92FS',
      category: 'Pistol',
      manufacturer: 'Beretta',
      model: '92FS',
      imagePath: 'assets/images/products/Beretta.png',
      description:
          'Beretta 92FS displayed as a catalog item within the ARMORY inventory interface.',
      status: 'Maintenance',
    ),
    Product(
      id: 'ARM-004',
      name: 'Glock 17',
      category: 'Pistol',
      manufacturer: 'Glock',
      model: '17',
      imagePath: 'assets/images/products/glock17.jpg',
      description:
          'Glock 17 displayed as a catalog item within the ARMORY inventory interface.',
      status: 'Available',
    ),
    Product(
      id: 'ARM-005',
      name: 'HK416',
      category: 'Rifle',
      manufacturer: 'Heckler & Koch',
      model: 'HK416',
      imagePath: 'assets/images/products/HK416.webp',
      description:
          'HK416 displayed as a catalog item within the ARMORY inventory interface.',
      status: 'Maintenance',
    ),
    Product(
      id: 'ARM-006',
      name: 'M1911',
      category: 'Pistol',
      manufacturer: 'Colt',
      model: 'M1911',
      imagePath: 'assets/images/products/M1911.jpg',
      description:
          'M1911 displayed as a catalog item within the ARMORY inventory interface.',
      status: 'Available',
    ),
    Product(
      id: 'ARM-007',
      name: 'FN SCAR',
      category: 'Rifle',
      manufacturer: 'FN Herstal',
      model: 'SCAR',
      imagePath: 'assets/images/products/SCAR.jpg',
      description:
          'FN SCAR displayed as a catalog item within the ARMORY inventory interface.',
      status: 'Reserved',
    ),
    Product(
      id: 'ARM-008',
      name: 'SIG Sauer P320',
      category: 'Pistol',
      manufacturer: 'SIG Sauer',
      model: 'P320',
      imagePath: 'assets/images/products/SIGP320.jpg',
      description:
          'SIG Sauer P320 displayed as a catalog item within the ARMORY inventory interface.',
      status: 'Available',
    ),
  ];
}